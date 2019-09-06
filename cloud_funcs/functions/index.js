const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.pushOrderNotifToShop = functions.firestore.document('orders/{ordersId}').onCreate((snapshot, context) => {
  const topic = snapshot.data().shop_username;
  var message = "Trrrrrring!!!";
  var msgbody = "You have a new order!";
  var payload = {
    notification: {
      title: message,
      body: msgbody,
    }
  };
  admin.messaging().sendToTopic(topic, payload)
  .then(function(response) {
    console.log("Successfully sent message to " + topic, response);
    return 1;
  })
  .catch(function(error) {
    console.log("Error sending message:", error);
    return 1;
  });
  return true;
});

exports.pushOrderNotifToCustomer = functions.firestore.document('orders/{ordersId}').onUpdate((snapshot, context) => {
  const topic = snapshot.after.data().customer_username;
  console.log(topic, 'a');
  var message = "Order Update!";
  var statusMsg = [
    "Order Rejected ",
    "Order placed! Waiting for approval from shop.",
    "Order Approved, please pay to continue.",
    "Payment Received. Your order is being prepared!",
    "Your order is ready! Please collect your order with pin: " + snapshot.after.data().unique_no,
    "Order Collected! Please rate your experience."
  ];
  var msgbody = statusMsg[snapshot.after.data().status];
  var payload = {
    notification: {
      title: message,
      body: msgbody,
    }
  };
  console.log(message + ":" + msgbody, 'response');
  admin.messaging().sendToTopic(topic, payload)
  .then(function(response) {
    console.log(message + ":" + msgbody, response);
    console.log("Successfully sent message to " + topic, response);
    return 1;
  })
  .catch(function(error) {
    console.log(message + ":" + msgbody, response);
    console.log("Error sending message:", error);
    return 1;
  });
  return true;
});
