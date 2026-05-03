import React, { useState } from "react";

function NewOrders() {
  const [newOrders, setNewOrders] = useState([
    { id: "ORD-1006", customer: "Sneha Reddy", date: "2026-05-02", amount: 1899, status: "Pending", payment: "Pending", items: 3 },
    { id: "ORD-1007", customer: "Rahul Verma", date: "2026-05-02", amount: 2499, status: "Pending", payment: "Pending", items: 2 },
    { id: "ORD-1008", customer: "Anjali Nair", date: "2026-05-01", amount: 599, status: "Pending", payment: "Pending", items: 1 },
  ]);

  const handleApprove = (id) => {
    alert(`Order ${id} approved and moved to processing`);
  };

  const handleCancel = (id) => {
    alert(`Order ${id} cancelled`);
  };

  return (
    <div className="min-h-screen">
      <div className="mb-8">
        <h2 className="text-2xl font-bold text-gray-800 mb-2">New Orders</h2>
        <p className="text-gray-500">Review and process new orders</p>
      </div>

      <div className="bg-white border border-gray-200 rounded-2xl p-6 shadow-md">
        <div className="space-y-4">
          {newOrders.map(order => (
            <div key={order.id} className="border border-gray-200 rounded-xl p-4 hover:shadow-lg transition-all">
              <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                <div>
                  <h3 className="font-bold text-gray-800">{order.id}</h3>
                  <p className="text-gray-600">{order.customer}</p>
                  <p className="text-sm text-gray-500">{order.date} • {order.items} items</p>
                </div>
                <div className="text-right">
                  <p className="text-xl font-bold text-orange-600">₹{order.amount.toLocaleString()}</p>
                  <span className="inline-block px-2 py-1 bg-yellow-100 text-yellow-800 rounded-full text-xs mt-1">Pending</span>
                </div>
                <div className="flex gap-2">
                  <button onClick={() => handleApprove(order.id)} className="px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600">
                    Approve
                  </button>
                  <button onClick={() => handleCancel(order.id)} className="px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600">
                    Cancel
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

export default NewOrders;