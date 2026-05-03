import React, { useState } from "react";

function PendingOrders() {
  const [searchTerm, setSearchTerm] = useState("");
  const [pendingOrders, setPendingOrders] = useState([
    { id: "ORD-1001", customer: "Rajesh Kumar", date: "2026-05-02", amount: 1047, payment: "COD", status: "Pending" },
    { id: "ORD-1002", customer: "Priya Sharma", date: "2026-05-02", amount: 3996, payment: "Card", status: "Pending" },
    { id: "ORD-1003", customer: "Amit Singh", date: "2026-05-01", amount: 1143, payment: "UPI", status: "Pending" },
    { id: "ORD-1004", customer: "Neha Gupta", date: "2026-05-01", amount: 5298, payment: "Card", status: "Pending" },
    { id: "ORD-1005", customer: "Vikram Mehta", date: "2026-04-30", amount: 747, payment: "COD", status: "Pending" },
  ]);

  const handleProcess = (id) => {
    alert(`Order ${id} moved to processing`);
  };

  const filteredOrders = pendingOrders.filter(order =>
    order.id.toLowerCase().includes(searchTerm.toLowerCase()) ||
    order.customer.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="min-h-screen bg-gradient-to-br from-orange-50 via-red-50 to-amber-50">
      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-6 sm:mb-8">
          <h2 className="text-2xl sm:text-3xl font-bold text-gray-800 mb-2">Pending Orders</h2>
          <p className="text-sm sm:text-base text-gray-500">Orders waiting for processing</p>
        </div>

        {/* Search Bar */}
        <div className="bg-white border border-gray-200 rounded-2xl p-4 sm:p-5 mb-6 shadow-md">
          <input
            type="text"
            placeholder="Search by Order ID or Customer name..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full px-4 py-2 sm:py-3 border border-gray-300 rounded-xl focus:outline-none focus:border-orange-500 text-sm sm:text-base"
          />
        </div>

        {/* Desktop Table View - Hidden on Mobile */}
        <div className="hidden md:block bg-white border border-gray-200 rounded-2xl overflow-hidden shadow-md">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50 border-b">
                <tr>
                  <th className="px-4 sm:px-6 py-3 text-left text-xs font-medium text-gray-500">Order ID</th>
                  <th className="px-4 sm:px-6 py-3 text-left text-xs font-medium text-gray-500">Customer</th>
                  <th className="px-4 sm:px-6 py-3 text-left text-xs font-medium text-gray-500">Date</th>
                  <th className="px-4 sm:px-6 py-3 text-left text-xs font-medium text-gray-500">Amount</th>
                  <th className="px-4 sm:px-6 py-3 text-left text-xs font-medium text-gray-500">Payment</th>
                  <th className="px-4 sm:px-6 py-3 text-left text-xs font-medium text-gray-500">Action</th>
                </tr>
              </thead>
              <tbody className="divide-y">
                {filteredOrders.map(order => (
                  <tr key={order.id} className="hover:bg-gray-50 transition-all">
                    <td className="px-4 sm:px-6 py-4 font-medium text-sm">{order.id}</td>
                    <td className="px-4 sm:px-6 py-4 text-sm">{order.customer}</td>
                    <td className="px-4 sm:px-6 py-4 text-sm">{order.date}</td>
                    <td className="px-4 sm:px-6 py-4 font-semibold text-sm">₹{order.amount.toLocaleString()}</td>
                    <td className="px-4 sm:px-6 py-4 text-sm">{order.payment}</td>
                    <td className="px-4 sm:px-6 py-4">
                      <button 
                        onClick={() => handleProcess(order.id)} 
                        className="px-3 py-1.5 bg-blue-500 text-white rounded-lg text-xs sm:text-sm hover:bg-blue-600 transition-all"
                      >
                        Process
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* Mobile Card View - Visible only on Mobile */}
        <div className="md:hidden space-y-4">
          {filteredOrders.map(order => (
            <div key={order.id} className="bg-white border border-gray-200 rounded-2xl p-4 shadow-md">
              <div className="flex justify-between items-start mb-3">
                <div>
                  <h3 className="font-bold text-gray-800">{order.id}</h3>
                  <p className="text-sm text-gray-600">{order.customer}</p>
                </div>
                <span className="text-lg font-bold text-orange-600">₹{order.amount.toLocaleString()}</span>
              </div>
              <div className="space-y-2 mb-4">
                <div className="flex justify-between text-sm">
                  <span className="text-gray-500">Date:</span>
                  <span className="text-gray-700">{order.date}</span>
                </div>
                <div className="flex justify-between text-sm">
                  <span className="text-gray-500">Payment:</span>
                  <span className="text-gray-700">{order.payment}</span>
                </div>
              </div>
              <button 
                onClick={() => handleProcess(order.id)} 
                className="w-full py-2 bg-blue-500 text-white rounded-xl text-sm font-medium hover:bg-blue-600 transition-all"
              >
                Process Order
              </button>
            </div>
          ))}
        </div>

        {filteredOrders.length === 0 && (
          <div className="bg-white border border-gray-200 rounded-2xl p-8 sm:p-12 text-center">
            <div className="text-4xl sm:text-6xl mb-4">📦</div>
            <h3 className="text-lg sm:text-xl font-semibold text-gray-800 mb-2">No pending orders</h3>
            <p className="text-sm sm:text-base text-gray-500">All orders have been processed</p>
          </div>
        )}
      </div>
    </div>
  );
}

export default PendingOrders;