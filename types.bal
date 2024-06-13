public type CreditCardInfo record {
    string cardNumber;
    string cardHolder;
    string expiryDate;
    string cvv;
};

public type ActionRequest record {
    string actionId;
    string encodedActionPayload?;
};

public type ActionResponse record {
    string actionId;
    string encodedResponsePayload;
};