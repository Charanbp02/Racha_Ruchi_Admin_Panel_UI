import React, { useState } from "react";

function CompletedOrders() {
  const [completedOrders] = useState([
    { id: "ORD-1004", customer: "Neha Gupta", date: "2026-04-28", deliveredDate: "2026-05-01", amount: 5298, items: 2 },
    { id: "ORD-1010", customer: "Suresh Kumar", date: "2026-04-27", deliveredDate: "2026-04-30", amount: 899, items: 1 },
    { id: "ORD-1011", customer: "Meera Singh", date: "2026-04-26", deliveredDate: "2026-04-29", amount: 3499, items: 3 },
  ]);

  return (
    <div className="min-h-screen">
      <div className="mb-8">
        <h2 className="text-2xl font-bold text-gray-800 mb-2">Completed Orders</h2>
        <p className="text-gray-500">Successfully delivered orders</p>
      </div>

      <div className="bg-white border border-gray-200 rounded-2xl overflow-hidden shadow-md">
        <table className="w-full">
          <thead className="bg-gray-50 border-b">
            <tr>
              <th className="px-6 py-3 text-left">Order ID</th>
              <th className="px-6 py-3 text-left">Customer</th>
              <th className="px-6 py-3 text-left">Order Date</th>
              <th className="px-6 py-3 text-left">Delivered Date</th>
              <th className="px-6 py-3 text-left">Items</th>
              <th className="px-6 py-3 text-left">Amount</th>
             </tr>
          </thead>
          <tbody className="divide-y">
            {completedOrders.map(order => (
              <tr key={order.id} className="hover:bg-gray-50">
                <td className="px-6 py-4 font-medium">{order.id}</td>
                <td className="px-6 py-4">{order.customer}</td>
                <td className="px-6 py-4">{order.date}</td>
                <td className="px-6 py-4">{order.deliveredDate}</td>
                <td className="px-6 py-4">{order.items}</td>
                <td className="px-6 py-4">₹{order.amount.toLocaleString()}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default CompletedOrders;