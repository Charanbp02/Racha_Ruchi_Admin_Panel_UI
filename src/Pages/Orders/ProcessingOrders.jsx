import React, { useState } from "react";

function ProcessingOrders() {
  const [processingOrders, setProcessingOrders] = useState([
    { id: "ORD-1002", customer: "Priya Sharma", date: "2026-04-30", amount: 3996, status: "Processing", items: 2 },
    { id: "ORD-1009", customer: "Kiran Raj", date: "2026-05-01", amount: 1499, status: "Processing", items: 3 },
  ]);

  const handleShip = (id) => {
    alert(`Order ${id} marked as shipped`);
  };

  return (
    <div className="min-h-screen">
      <div className="mb-8">
        <h2 className="text-2xl font-bold text-gray-800 mb-2">Processing Orders</h2>
        <p className="text-gray-500">Orders currently being processed</p>
      </div>

      <div className="bg-white border border-gray-200 rounded-2xl overflow-hidden shadow-md">
        <table className="w-full">
          <thead className="bg-gray-50 border-b">
            <tr>
              <th className="px-6 py-3 text-left">Order ID</th>
              <th className="px-6 py-3 text-left">Customer</th>
              <th className="px-6 py-3 text-left">Date</th>
              <th className="px-6 py-3 text-left">Items</th>
              <th className="px-6 py-3 text-left">Amount</th>
              <th className="px-6 py-3 text-left">Action</th>
             </tr>
          </thead>
          <tbody className="divide-y">
            {processingOrders.map(order => (
              <tr key={order.id} className="hover:bg-gray-50">
                <td className="px-6 py-4 font-medium">{order.id}</td>
                <td className="px-6 py-4">{order.customer}</td>
                <td className="px-6 py-4">{order.date}</td>
                <td className="px-6 py-4">{order.items}</td>
                <td className="px-6 py-4">₹{order.amount.toLocaleString()}</td>
                <td className="px-6 py-4">
                  <button onClick={() => handleShip(order.id)} className="px-3 py-1 bg-blue-500 text-white rounded-lg text-sm">
                    Mark Shipped
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

export default ProcessingOrders;