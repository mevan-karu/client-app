import ballerina/lang.array;
import client_app.com.cossacklabs.themis;

public function encryptData(byte[] dataToBeEncrypted) returns byte[]|error {
    themis:PrivateKey privateKey = check themis:newPrivateKey1(check array:fromBase64(encodedClientPrivateKey));
    themis:PublicKey publicKey = check themis:newPublicKey1(check array:fromBase64(encodedServerPublicKey));
    themis:SecureMessage secureMessage = themis:newSecureMessage2(privateKey, publicKey);
    byte[] encryptedData = check secureMessage.wrap(dataToBeEncrypted);
    return encryptedData;
}

public function decryptData(byte[] dataToBeDecrypted) returns byte[]|error {
    themis:PrivateKey privateKey = check themis:newPrivateKey1(check array:fromBase64(encodedClientPrivateKey));
    themis:PublicKey publicKey = check themis:newPublicKey1(check array:fromBase64(encodedServerPublicKey));
    themis:SecureMessage secureMessage = themis:newSecureMessage2(privateKey, publicKey);
    byte[] decryptedData = check secureMessage.unwrap(dataToBeDecrypted);
    return decryptedData;
}
