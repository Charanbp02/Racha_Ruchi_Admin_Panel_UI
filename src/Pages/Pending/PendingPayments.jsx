import React, { useState } from "react";

function PendingPayments() {
  const [searchTerm, setSearchTerm] = useState("");
  const [pendingPayments, setPendingPayments] = useState([
    { id: "PAY-001", orderId: "ORD-1001", customer: "Rajesh Kumar", amount: 1047, method: "COD", date: "2026-05-02", status: "Awaiting" },
    { id: "PAY-002", orderId: "ORD-1004", customer: "Neha Gupta", amount: 5298, method: "Card", date: "2026-05-01", status: "Failed" },
    { id: "PAY-003", orderId: "ORD-1005", customer: "Vikram Mehta", amount: 747, method: "UPI", date: "2026-04-30", status: "Pending" },
    { id: "PAY-004", orderId: "ORD-1002", customer: "Priya Sharma", amount: 3996, method: "Card", date: "2026-05-02", status: "Awaiting" },
  ]);

  const handleVerify = (id) => {
    alert(`Payment ${id} verified successfully`);
  };

  const getStatusBadge = (status) => {
    const colors = {
      Awaiting: "bg-yellow-100 text-yellow-800",
      Failed: "bg-red-100 text-red-800",
      Pending: "bg-orange-100 text-orange-800",
    };
    return <span className={`px-2 py-1 rounded-full text-xs font-medium ${colors[status]}`}>{status}</span>;
  };

  const filteredPayments = pendingPayments.filter(payment =>
    payment.id.toLowerCase().includes(searchTerm.toLowerCase()) ||
    payment.orderId.toLowerCase().includes(searchTerm.toLowerCase()) ||
    payment.customer.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="min-h-screen bg-gradient-to-br from-orange-50 via-red-50 to-amber-50">
      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-6 sm:mb-8">
          <h2 className="text-2xl sm:text-3xl font-bold text-gray-800 mb-2">Pending Payments</h2>
          <p className="text-sm sm:text-base text-gray-500">Payments awaiting confirmation</p>
        </div>

        {/* Search Bar */}
        <div className="bg-white border border-gray-200 rounded-2xl p-4 sm:p-5 mb-6 shadow-md">
          <input
            type="text"
            placeholder="Search by Payment ID, Order ID or Customer..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full px-4 py-2 sm:py-3 border border-gray-300 rounded-xl focus:outline-none focus:border-orange-500 text-sm sm:text-base"
          />
        </div>

        {/* Desktop Table View */}
        <div className="hidden md:block bg-white border border-gray-200 rounded-2xl overflow-hidden shadow-md">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50 border-b">
                <tr>
                  <th className="px-4 sm:px-6 py-3 text-left text-xs font-medium text-gray-500">Payment ID</th>
                  <th className="px-4 sm:px-6 py-3 text-left text-xs font-medium text-gray-500">Order ID</th>
                  <th className="px-4 sm:px-6 py-3 text-left text-xs font-medium text-gray-500">Customer</th>
                  <th className="px-4 sm:px-6 py-3 text-left text-xs font-medium text-gray-500">Amount</th>
                  <th className="px-4 sm:px-6 py-3 text-left text-xs font-medium text-gray-500">Method</th>
                  <th className="px-4 sm:px-6 py-3 text-left text-xs font-medium text-gray-500">Status</th>
                  <th className="px-4 sm:px-6 py-3 text-left text-xs font-medium text-gray-500">Action</th>
                </tr>
              </thead>
              <tbody className="divide-y">
                {filteredPayments.map(payment => (
                  <tr key={payment.id} className="hover:bg-gray-50 transition-all">
                    <td className="px-4 sm:px-6 py-4 font-medium text-sm">{payment.id}</td>
                    <td className="px-4 sm:px-6 py-4 text-sm">{payment.orderId}</td>
                    <td className="px-4 sm:px-6 py-4 text-sm">{payment.customer}</td>
                    <td className="px-4 sm:px-6 py-4 font-semibold text-sm">₹{payment.amount.toLocaleString()}</td>
                    <td className="px-4 sm:px-6 py-4 text-sm">{payment.method}</td>
                    <td className="px-4 sm:px-6 py-4">{getStatusBadge(payment.status)}</td>
                    <td className="px-4 sm:px-6 py-4">
                      <button 
                        onClick={() => handleVerify(payment.id)} 
                        className="px-3 py-1.5 bg-green-500 text-white rounded-lg text-xs sm:text-sm hover:bg-green-600 transition-all"
                      >
                        Verify
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* Mobile Card View */}
        <div className="md:hidden space-y-4">
          {filteredPayments.map(payment => (
            <div key={payment.id} className="bg-white border border-gray-200 rounded-2xl p-4 shadow-md">
              <div className="flex justify-between items-start mb-3">
                <div>
                  <h3 className="font-bold text-gray-800">{payment.id}</h3>
                  <p className="text-sm text-gray-600">Order: {payment.orderId}</p>
                </div>
                <span className="text-lg font-bold text-green-600">₹{payment.amount.toLocaleString()}</span>
              </div>
              <div className="space-y-2 mb-4">
                <div className="flex justify-between text-sm">
                  <span className="text-gray-500">Customer:</span>
                  <span className="text-gray-700">{payment.customer}</span>
                </div>
                <div className="flex justify-between text-sm">
                  <span className="text-gray-500">Method:</span>
                  <span className="text-gray-700">{payment.method}</span>
                </div>
                <div className="flex justify-between text-sm">
                  <span className="text-gray-500">Status:</span>
                  {getStatusBadge(payment.status)}
                </div>
              </div>
              <button 
                onClick={() => handleVerify(payment.id)} 
                className="w-full py-2 bg-green-500 text-white rounded-xl text-sm font-medium hover:bg-green-600 transition-all"
              >
                Verify Payment
              </button>
            </div>
          ))}
        </div>

        {filteredPayments.length === 0 && (
          <div className="bg-white border border-gray-200 rounded-2xl p-8 sm:p-12 text-center">
            <div className="text-4xl sm:text-6xl mb-4">💰</div>
            <h3 className="text-lg sm:text-xl font-semibold text-gray-800 mb-2">No pending payments</h3>
            <p className="text-sm sm:text-base text-gray-500">All payments have been verified</p>
          </div>
        )}
      </div>
    </div>
  );
}

export default PendingPayments;