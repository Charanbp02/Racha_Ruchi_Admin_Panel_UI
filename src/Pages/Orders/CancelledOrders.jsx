import React, { useState } from "react";

function CancelledOrders() {
  const [cancelledOrders] = useState([
    { id: "ORD-1005", customer: "Vikram Mehta", date: "2026-04-27", cancelledDate: "2026-04-28", amount: 747, reason: "Customer request", refund: "Processed" },
    { id: "ORD-1012", customer: "Deepa Nair", date: "2026-04-25", cancelledDate: "2026-04-26", amount: 1299, reason: "Out of stock", refund: "Pending" },
  ]);

  return (
    <div className="min-h-screen">
      <div className="mb-8">
        <h2 className="text-2xl font-bold text-gray-800 mb-2">Cancelled Orders</h2>
        <p className="text-gray-500">Orders that have been cancelled</p>
      </div>

      <div className="bg-white border border-gray-200 rounded-2xl overflow-hidden shadow-md">
        <table className="w-full">
          <thead className="bg-gray-50 border-b">
            <tr>
              <th className="px-6 py-3 text-left">Order ID</th>
              <th className="px-6 py-3 text-left">Customer</th>
              <th className="px-6 py-3 text-left">Order Date</th>
              <th className="px-6 py-3 text-left">Cancelled Date</th>
              <th className="px-6 py-3 text-left">Amount</th>
              <th className="px-6 py-3 text-left">Reason</th>
              <th className="px-6 py-3 text-left">Refund</th>
             </tr>
          </thead>
          <tbody className="divide-y">
            {cancelledOrders.map(order => (
              <tr key={order.id} className="hover:bg-gray-50">
                <td className="px-6 py-4 font-medium">{order.id}</td>
                <td className="px-6 py-4">{order.customer}</td>
                <td className="px-6 py-4">{order.date}</td>
                <td className="px-6 py-4">{order.cancelledDate}</td>
                <td className="px-6 py-4">₹{order.amount.toLocaleString()}</td>
                <td className="px-6 py-4">{order.reason}</td>
                <td className="px-6 py-4">
                  <span className={`px-2 py-1 rounded-full text-xs ${order.refund === "Processed" ? "bg-green-100 text-green-600" : "bg-yellow-100 text-yellow-600"}`}>
                    {order.refund}
                  </span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default CancelledOrders;