import ballerina/http;
import ballerina/io;

string bookStoreServiceUrl = "http://localhost:9090";

// response type of the "/books" endpoint
type Book record {|
    readonly string id;
    string name;
    string description;
    int quantityAvailable;
|};

// payload type of the "/orders" endpoint
type OrderItem record {|
    string id;
    int quantity;
|};

// -------------------------
//        Task 1
// -------------------------
// 1. Create an http client and assign the name "bookStoreClient" to it.
// 2. Use the "bookStoreServiceUrl" defined at the top to set the service URL of the client.
// HINT: check https://ballerina.io/learn/by-example/http-client-send-request-receive-response/
http:Client bookStoreClient = check new (bookStoreServiceUrl);

public function main() returns error? {
    // -------------------------
    //        Task 2
    // -------------------------
    // 1. Use "bookStoreClient" to send a GET request to the "/books" endpoint to get a catalog of all available books.
    // 2. Assign the received response to a variable name "catalog" which is an array of the type "Book"(Book[]).
    // HINT: https://central.ballerina.io/ballerina/http/latest#security
    // HINT: Use `check` keyword at the front of the endpoint call to throw errors.
    Book[] catalog = check bookStoreClient->get("/books");

    OrderItem[] orderItems = [];
    printBooks(catalog);

    io:println("\nINSTRUCTIONS:\nEnter the IDs of the books you would like to order.\nHave them separated by commas.\n(eg: b01,b03,b04)\n");
    string bookIdInput = io:readln("Enter the book IDs:");
    string:RegExp commaReg = re `,`;
    string[] bookIds = commaReg.split(bookIdInput);

    io:println("\nINSTRUCTIONS:\nEnter the quantity you'd like to order from each book.\nYou can provide '0' to remove a book from your order\n");
    foreach string bookId in bookIds {
        string:RegExp spaceReg = re ` `;
        string bookIdFixed = spaceReg.replaceAll(bookId, "");
        string quantity = io:readln(string `Enter quantity for book ${bookIdFixed}: `);
        io:println();
        orderItems.push({id: bookIdFixed, quantity: check int:fromString(quantity)});
    }

    // -------------------------
    //        Task 3
    // -------------------------
    // 1. Use "bookStoreClient" to send a POST request to the "/orders" endpoint to create an order.
    // 2. The expected payload is an array of type "OrderItem" defined at the top(OrderItem[]).
    // 3. Pass the "orderItems" collected in previous step as the payload.
    // 3. Assign the received response to a variable name "orderResponse" which is of type "http:Response|http:ClientError"(This means the received could be either http:Response or http:ClientError).
    // HINT: Check https://ballerina.io/learn/by-example/http-client-send-request-receive-response/ on how to send a POST request with a payload.

    http:Response|http:ClientError orderResponse = check bookStoreClient->post("/orders", orderItems);

    if orderResponse is http:ClientError {
            io:println(orderResponse.detail());
            return;
    }
    io:println(orderResponse.getJsonPayload());
}

// -------------------------
//        Task 4
// -------------------------
// 1. Open a terminal, navigate to the root of this project(bookstore_execise) and execute `bal run` command.
// 2. Follow the instructions shown on the terminal and provide correct inputs to place a successful order.

function printBooks(Book[] catalog) {
    io:println("--------------------------------------------------------------");
    io:println(string `book ID  |  Book Name  |  Description  |  Quantity Available`);
    io:println();
    foreach Book book in catalog {
        string shortDesc = string `${book.description.substring(0, 20)}...`;
        io:println(string `${book.id}  |  ${book.name}  |  ${shortDesc}  |  ${book.quantityAvailable}`);
        io:println();
    }
    io:println("--------------------------------------------------------------");
}
