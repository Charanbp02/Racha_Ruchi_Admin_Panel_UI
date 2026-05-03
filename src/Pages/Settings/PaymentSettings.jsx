import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Save, CreditCard, DollarSign, Banknote, Receipt, Lock } from "lucide-react";

function PaymentSettings() {
  const navigate = useNavigate();
  const [showNotification, setShowNotification] = useState(false);
  const [paymentSettings, setPaymentSettings] = useState({
    currency: "INR",
    taxRate: "18",
    enableCOD: true,
    enableCard: true,
    enableUPI: true,
    enableWallet: false,
    razorpayKey: "",
    razorpaySecret: "",
    stripeKey: "",
    stripeSecret: "",
    minOrderAmount: "100",
    maxOrderAmount: "50000",
    codCharge: "0",
    paymentGateway: "razorpay"
  });

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    setPaymentSettings({
      ...paymentSettings,
      [name]: type === "checkbox" ? checked : value
    });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    setShowNotification(true);
    setTimeout(() => setShowNotification(false), 3000);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      {showNotification && (
        <div className="fixed top-20 right-4 z-50 bg-green-500 text-white px-6 py-3 rounded-xl shadow-lg">
          Payment settings saved successfully
        </div>
      )}

      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-8">
          <h1 className="text-3xl lg:text-4xl font-bold bg-gradient-to-r from-gray-700 to-gray-900 bg-clip-text text-transparent">
            Payment Settings
          </h1>
          <p className="text-gray-500 mt-2">Configure payment gateways and options</p>
        </div>

        <div className="max-w-4xl">
          <form onSubmit={handleSubmit} className="space-y-6">
            {/* Currency & Tax */}
            <div className="bg-white rounded-2xl shadow-sm p-6 md:p-8">
              <h2 className="text-xl font-bold text-gray-800 mb-4 flex items-center gap-2">
                <DollarSign className="w-5 h-5 text-blue-600" />
                Currency & Tax Settings
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">Currency</label>
                  <select
                    name="currency"
                    value={paymentSettings.currency}
                    onChange={handleChange}
                    className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                  >
                    <option value="INR">Indian Rupee (INR)</option>
                    <option value="USD">US Dollar (USD)</option>
                    <option value="EUR">Euro (EUR)</option>
                    <option value="GBP">British Pound (GBP)</option>
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">Tax Rate (%)</label>
                  <input
                    type="text"
                    name="taxRate"
                    value={paymentSettings.taxRate}
                    onChange={handleChange}
                    className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
              </div>
            </div>

            {/* Payment Methods */}
            <div className="bg-white rounded-2xl shadow-sm p-6 md:p-8">
              <h2 className="text-xl font-bold text-gray-800 mb-4 flex items-center gap-2">
                <Banknote className="w-5 h-5 text-green-600" />
                Payment Methods
              </h2>
              <div className="space-y-3">
                <label className="flex items-center justify-between cursor-pointer">
                  <div>
                    <p className="font-medium text-gray-800">Cash on Delivery (COD)</p>
                    <p className="text-sm text-gray-500">Allow customers to pay cash on delivery</p>
                  </div>
                  <input
                    type="checkbox"
                    name="enableCOD"
                    checked={paymentSettings.enableCOD}
                    onChange={handleChange}
                    className="w-5 h-5 text-green-600 rounded focus:ring-green-500"
                  />
                </label>
                <label className="flex items-center justify-between cursor-pointer">
                  <div>
                    <p className="font-medium text-gray-800">Credit/Debit Card</p>
                    <p className="text-sm text-gray-500">Accept card payments</p>
                  </div>
                  <input
                    type="checkbox"
                    name="enableCard"
                    checked={paymentSettings.enableCard}
                    onChange={handleChange}
                    className="w-5 h-5 text-green-600 rounded focus:ring-green-500"
                  />
                </label>
                <label className="flex items-center justify-between cursor-pointer">
                  <div>
                    <p className="font-medium text-gray-800">UPI Payments</p>
                    <p className="text-sm text-gray-500">Accept UPI payments (Google Pay, PhonePe, etc.)</p>
                  </div>
                  <input
                    type="checkbox"
                    name="enableUPI"
                    checked={paymentSettings.enableUPI}
                    onChange={handleChange}
                    className="w-5 h-5 text-green-600 rounded focus:ring-green-500"
                  />
                </label>
                <label className="flex items-center justify-between cursor-pointer">
                  <div>
                    <p className="font-medium text-gray-800">Digital Wallet</p>
                    <p className="text-sm text-gray-500">Accept payments via digital wallets</p>
                  </div>
                  <input
                    type="checkbox"
                    name="enableWallet"
                    checked={paymentSettings.enableWallet}
                    onChange={handleChange}
                    className="w-5 h-5 text-green-600 rounded focus:ring-green-500"
                  />
                </label>
              </div>
            </div>

            {/* Payment Gateway */}
            <div className="bg-white rounded-2xl shadow-sm p-6 md:p-8">
              <h2 className="text-xl font-bold text-gray-800 mb-4 flex items-center gap-2">
                <Lock className="w-5 h-5 text-purple-600" />
                Payment Gateway Configuration
              </h2>
              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">Select Gateway</label>
                  <select
                    name="paymentGateway"
                    value={paymentSettings.paymentGateway}
                    onChange={handleChange}
                    className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                  >
                    <option value="razorpay">Razorpay</option>
                    <option value="stripe">Stripe</option>
                    <option value="paypal">PayPal</option>
                  </select>
                </div>
                {paymentSettings.paymentGateway === "razorpay" && (
                  <>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">Razorpay Key ID</label>
                      <input
                        type="text"
                        name="razorpayKey"
                        value={paymentSettings.razorpayKey}
                        onChange={handleChange}
                        className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">Razorpay Key Secret</label>
                      <input
                        type="password"
                        name="razorpaySecret"
                        value={paymentSettings.razorpaySecret}
                        onChange={handleChange}
                        className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                      />
                    </div>
                  </>
                )}
                {paymentSettings.paymentGateway === "stripe" && (
                  <>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">Stripe Publishable Key</label>
                      <input
                        type="text"
                        name="stripeKey"
                        value={paymentSettings.stripeKey}
                        onChange={handleChange}
                        className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">Stripe Secret Key</label>
                      <input
                        type="password"
                        name="stripeSecret"
                        value={paymentSettings.stripeSecret}
                        onChange={handleChange}
                        className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                      />
                    </div>
                  </>
                )}
              </div>
            </div>

            {/* Order Limits */}
            <div className="bg-white rounded-2xl shadow-sm p-6 md:p-8">
              <h2 className="text-xl font-bold text-gray-800 mb-4 flex items-center gap-2">
                <Receipt className="w-5 h-5 text-orange-600" />
                Order Limits
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">Minimum Order Amount</label>
                  <input
                    type="text"
                    name="minOrderAmount"
                    value={paymentSettings.minOrderAmount}
                    onChange={handleChange}
                    className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">Maximum Order Amount</label>
                  <input
                    type="text"
                    name="maxOrderAmount"
                    value={paymentSettings.maxOrderAmount}
                    onChange={handleChange}
                    className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">COD Charge (₹)</label>
                  <input
                    type="text"
                    name="codCharge"
                    value={paymentSettings.codCharge}
                    onChange={handleChange}
                    className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
              </div>
            </div>

            {/* Buttons */}
            <div className="flex gap-4">
              <button
                type="button"
                onClick={() => navigate("/settings")}
                className="flex-1 px-6 py-3 border border-gray-300 text-gray-700 rounded-xl font-medium hover:bg-gray-50 transition-all"
              >
                Cancel
              </button>
              <button
                type="submit"
                className="flex-1 px-6 py-3 bg-gradient-to-r from-gray-700 to-gray-900 text-white rounded-xl font-medium hover:shadow-lg transition-all flex items-center justify-center gap-2"
              >
                <Save className="w-5 h-5" />
                Save Payment Settings
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}

export default PaymentSettings;