import React, { useState } from "react";

function ReturnOrders() {
  const [returnOrders] = useState([
    { id: "ORD-1013", customer: "Mohan Das", date: "2026-04-28", returnDate: "2026-05-01", amount: 899, reason: "Damaged product", status: "Pending", action: "Review" },
    { id: "ORD-1014", customer: "Lakshmi Priya", date: "2026-04-27", returnDate: "2026-04-30", amount: 2499, reason: "Wrong item", status: "Approved", action: "Process refund" },
  ]);

  const handleAction = (id, action) => {
    alert(`${action} for order ${id}`);
  };

  return (
    <div className="min-h-screen">
      <div className="mb-8">
        <h2 className="text-2xl font-bold text-gray-800 mb-2">Return Orders</h2>
        <p className="text-gray-500">Manage product returns and refunds</p>
      </div>

      <div className="bg-white border border-gray-200 rounded-2xl overflow-hidden shadow-md">
        <table className="w-full">
          <thead className="bg-gray-50 border-b">
            <tr>
              <th className="px-6 py-3 text-left">Order ID</th>
              <th className="px-6 py-3 text-left">Customer</th>
              <th className="px-6 py-3 text-left">Order Date</th>
              <th className="px-6 py-3 text-left">Return Date</th>
              <th className="px-6 py-3 text-left">Amount</th>
              <th className="px-6 py-3 text-left">Reason</th>
              <th className="px-6 py-3 text-left">Status</th>
              <th className="px-6 py-3 text-left">Action</th>
             </tr>
          </thead>
          <tbody className="divide-y">
            {returnOrders.map(order => (
              <tr key={order.id} className="hover:bg-gray-50">
                <td className="px-6 py-4 font-medium">{order.id}</td>
                <td className="px-6 py-4">{order.customer}</td>
                <td className="px-6 py-4">{order.date}</td>
                <td className="px-6 py-4">{order.returnDate}</td>
                <td className="px-6 py-4">₹{order.amount.toLocaleString()}</td>
                <td className="px-6 py-4">{order.reason}</td>
                <td className="px-6 py-4">
                  <span className={`px-2 py-1 rounded-full text-xs ${order.status === "Approved" ? "bg-green-100 text-green-600" : "bg-yellow-100 text-yellow-600"}`}>
                    {order.status}
                  </span>
                </td>
                <td className="px-6 py-4">
                  <button onClick={() => handleAction(order.id, order.action)} className="px-3 py-1 bg-orange-500 text-white rounded-lg text-sm">
                    {order.action}
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default ReturnOrders;