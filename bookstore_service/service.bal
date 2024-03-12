import ballerina/http;

service on new http:Listener(9090) {

    resource function get books() returns Book[] {
        return books.toArray();
    }

    resource function post orders(Order[] bookOrder) returns
        http:Accepted|http:NotAcceptable|http:NotFound {
        table<Book> key(id) inventoryCopy = books.clone();
        foreach var orderItem in bookOrder {
            Book? inventoryItem = inventoryCopy[orderItem.id];
            if inventoryItem is () {
                return <http:NotFound>{
                    body: {
                        message: string `Requested book '${orderItem.id}' not found`
                    }
                };
            }
            if inventoryItem.quantityAvailable < orderItem.quantity {
                return <http:NotAcceptable>{
                    body: {
                        message: string `Requested quantity is not available for '${orderItem.id}'`
                    }
                };
            }
            inventoryItem.quantityAvailable -= 1;
        }
        return <http:Accepted>{
            body: {
                message: "Congratulations! Your order was placed successfully."
            }
        };
    }
}
