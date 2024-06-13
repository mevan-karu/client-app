import ballerina/io;
import ballerina/http;
import ballerina/log;
import ballerina/lang.array;
import thisarug/prettify;

final http:Client productService = check new(
            productServiceEp,
            httpVersion = "1.1"
        );
final http:Client cardService = !securityEnabled ? check new(
            cardServiceEp,
            httpVersion = "1.1"
        ) : 
        check new(
            cardServiceEp,
            httpVersion = "1.1",
            auth = {
                clientConfig: {secureSocket: {disable: true}},
                tokenUrl: tokenEp,
                clientId: clientId,
                clientSecret: clientSecret
            }
        );

public function main() {
    boolean exit = false;
    while !exit {
        io:println("Select the scenario you want to run:");
        io:println("1. Scenario 1 - Listing the bank account types");
        io:println("2. Scenario 2 - Adding a new credit card detail");
        // io:println("3. Scenario 3 - Listing the credit card details");
        io:println("Type 'exit' to exit the program.");
        string scenario = io:readln("Enter the scenario number: ");
        do {
            match scenario {
                "1" => {
                    check listBankAccountTypes();
                }
                "2" => {
                    check addCreditCardDetail();
                }
                "3" => {
                    check listCreditCardDetails();
                }
                "exit" => {
                    exit = true;
                }
                _ => {
                    io:println("Invalid scenario number. Please try again.");
                }
            }
        } on fail var e {
            log:printError("Error occurred while performing action.", 'error = e);
        }
    }
}

function listBankAccountTypes() returns error? {
    // Implement the logic to list the bank account types
    io:println();
    io:println();
    io:println("--------- Listing the bank account types ----------");
    io:println("---------------------------------------------------");
    io:println();
    // Send the request to the system API
    http:Response response = check productService->/products;
    io:println("Bank Account Types: ", prettify:prettify(check response.getJsonPayload()));
    io:println();
    io:println("----- Bank account types listed successfully. -----");
    io:println("---------------------------------------------------");
    io:println();
    io:println();
}

function addCreditCardDetail() returns error? {
    // Implement the logic to add a new credit card detail
    io:println();
    io:println();
    io:println("----- Adding a new credit card detail -----");
    io:println("--------------------------------------------------");
    string creditCardNumber = io:readln("Enter the credit card number: ");
    string expiryDate = io:readln("Enter the expiry date: ");
    string cvv = io:readln("Enter the CVV: ");
    string cardHolderName = io:readln("Enter the card holder name: ");

    // Create the request payload
    CreditCardInfo payload = {
        cardNumber: creditCardNumber,
        expiryDate: expiryDate,
        cvv: cvv,
        cardHolder: cardHolderName
    };

    // Encrypt the payload.
    byte[] encryptedPayload = check encryptData(payload.toJsonString().toBytes());
    io:println("--------------------------------------------------");
    io:println("Encoded encrypted credit card details to be sent to the client: ", encryptedPayload.toBase64());
    io:println("--------------------------------------------------");
    // Send the request to the system API
    http:Request request = new;
    request.setBinaryPayload(encryptedPayload);
    http:Response response = check cardService->/credit\-cards.post(request);
    io:println("----- Credit card detail added successfully. -----");
    io:println("--------------------------------------------------");
    string encodedPayload = check string:fromBytes(check response.getBinaryPayload());
    io:println("Encoded encrypted credit card details from the service: " + encodedPayload);
    io:println("--------------------------------------------------");
    byte[] decryptedData = check decryptData(check array:fromBase64(encodedPayload));
    string creditCardInfoStr = check string:fromBytes(decryptedData);
    json creditCardInfo = check creditCardInfoStr.fromJsonString();
    io:println();
    io:println("Masked credit card details from the service: ", prettify:prettify(creditCardInfo));
    io:println("--------------------------------------------------");
    io:println();
    io:println();
}

function listCreditCardDetails() returns error? {
    // Implement the logic to list the credit card details
    io:println("----- Listing the credit card details -----");
}

