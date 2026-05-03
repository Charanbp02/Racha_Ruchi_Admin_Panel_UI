import React, { useState } from "react";

function AllOrders() {
  const [searchTerm, setSearchTerm] = useState("");
  const [statusFilter, setStatusFilter] = useState("All");

  const orders = [
    { id: "ORD-1001", customer: "Rajesh Kumar", date: "2026-05-01", amount: 1047, status: "Pending", payment: "Pending" },
    { id: "ORD-1002", customer: "Priya Sharma", date: "2026-04-30", amount: 3996, status: "Processing", payment: "Paid" },
    { id: "ORD-1003", customer: "Amit Singh", date: "2026-04-29", amount: 1143, status: "Shipped", payment: "Paid" },
    { id: "ORD-1004", customer: "Neha Gupta", date: "2026-04-28", amount: 5298, status: "Delivered", payment: "Paid" },
    { id: "ORD-1005", customer: "Vikram Mehta", date: "2026-04-27", amount: 747, status: "Cancelled", payment: "Refunded" },
  ];

  const filteredOrders = orders.filter(order => {
    const matchesSearch = order.id.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          order.customer.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = statusFilter === "All" || order.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const getStatusBadge = (status) => {
    const colors = {
      Pending: "bg-yellow-100 text-yellow-800",
      Processing: "bg-blue-100 text-blue-800",
      Shipped: "bg-purple-100 text-purple-800",
      Delivered: "bg-green-100 text-green-800",
      Cancelled: "bg-red-100 text-red-800",
    };
    return <span className={`px-2 py-1 rounded-full text-xs font-medium ${colors[status]}`}>{status}</span>;
  };

  return (
    <div className="min-h-screen">
      <div className="mb-8">
        <h2 className="text-2xl font-bold text-gray-800 mb-2">All Orders</h2>
        <p className="text-gray-500">View and manage all orders</p>
      </div>

      <div className="bg-white border border-gray-200 rounded-2xl p-5 mb-6 shadow-md">
        <div className="flex flex-col md:flex-row gap-4">
          <input
            type="text"
            placeholder="Search by Order ID or Customer..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="flex-1 px-4 py-2 border border-gray-300 rounded-xl"
          />
          <select value={statusFilter} onChange={(e) => setStatusFilter(e.target.value)} className="px-4 py-2 border border-gray-300 rounded-xl">
            <option value="All">All Status</option>
            <option value="Pending">Pending</option>
            <option value="Processing">Processing</option>
            <option value="Shipped">Shipped</option>
            <option value="Delivered">Delivered</option>
            <option value="Cancelled">Cancelled</option>
          </select>
        </div>
      </div>

      <div className="bg-white border border-gray-200 rounded-2xl overflow-hidden shadow-md">
        <table className="w-full">
          <thead className="bg-gray-50 border-b">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500">Order ID</th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500">Customer</th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500">Date</th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500">Amount</th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500">Status</th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500">Payment</th>
             </tr>
          </thead>
          <tbody className="divide-y">
            {filteredOrders.map(order => (
              <tr key={order.id} className="hover:bg-gray-50">
                <td className="px-6 py-4 font-medium">{order.id}</td>
                <td className="px-6 py-4">{order.customer}</td>
                <td className="px-6 py-4">{order.date}</td>
                <td className="px-6 py-4">₹{order.amount.toLocaleString()}</td>
                <td className="px-6 py-4">{getStatusBadge(order.status)}</td>
                <td className="px-6 py-4">{order.payment}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default AllOrders;