const express = require("express");
const app = express();

app.use(express.static("public"));
app.use(express.json());

// replace the test api key with your hyperswitch api key
const hyper = require("@juspay-tech/hyperswitch-node")(
  "<API-KEY>"
);

app.post("/create-payment", async (req, res) => {
  try {
    const paymentIntent = await hyper.paymentIntents.create({
      currency: "USD",
      amount: 100,
    });
    // Send publishable key and PaymentIntent details to client
    res.send({
      clientSecret: paymentIntent.client_secret,
    });
  } catch (err) {
    return res.status(400).send({
      error: {
        message: err.message,
      },
    });
  }
});

app.listen(4444, () => console.log("Node server listening on port 4444!"));


