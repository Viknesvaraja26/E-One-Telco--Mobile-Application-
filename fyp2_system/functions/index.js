/* eslint-disable max-len */
const functions = require("firebase-functions");
const stripe = require("stripe")("sk_test_51MfTu1KK6QmEe7qyH6qk2KC0wIHQdgb24U9Z0Alf74PlvXhoeiLC511Ym7cp6BJRgKDdWdimdXaoy4lp6mZryKlN00FHHo8kq1");

exports.stripePaymentIntentRequest = functions.https.onRequest(async (req, res) => {
  try {
    let customerId;

    // Gets the customer who's email id matches the one sent by the client
    const customerList = await stripe.customers.list({
      email: req.body.email,
      limit: 1,
    });

    // Checks the if the customer exists, if not creates a new customer
    if (customerList.data.length !== 0) {
      customerId = customerList.data[0].id;
    } else {
      const customer = await stripe.customers.create({
        email: req.body.email,
      });
      customerId = customer.data.id;
    }

    // Creates a temporary secret key linked with the customer
    const ephemeralKey = await stripe.ephemeralKeys.create(
        {customer: customerId},
        {apiVersion: "2022-11-15"},
    );

    // Creates a new payment intent with amount passed in from the client
    const paymentIntent = await stripe.paymentIntents.create({
      amount: parseInt(req.body.amount),
      currency: "myr",
      customer: customerId,
    });

    res.status(200).send({
      paymentIntent: paymentIntent.client_secret,
      ephemeralKey: ephemeralKey.secret,
      customer: customerId,
      success: true,
    });
  } catch (error) {
    res.status(404).send({success: false, error: error.message});
  }
});
