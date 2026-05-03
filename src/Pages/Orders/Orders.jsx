import React, { useState } from "react";
import { useNavigate } from "react-router-dom";

function Orders() {
  const navigate = useNavigate();

  const stats = {
    totalOrders: 1248,
    totalRevenue: 45280,
    pendingOrders: 45,
    deliveredOrders: 892,
  };

  return (
    <div className="min-h-screen">
      <div className="mb-8">
        <h2 className="text-2xl font-bold text-gray-800 mb-2">Order Management</h2>
        <p className="text-gray-500">Manage and track all customer orders</p>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <div className="bg-white border border-gray-200 rounded-2xl p-5 shadow-md">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-gray-500 text-sm">Total Orders</p>
              <h3 className="text-3xl font-bold text-gray-800 mt-1">{stats.totalOrders}</h3>
            </div>
            <div className="w-12 h-12 rounded-xl bg-orange-100 flex items-center justify-center text-2xl">O</div>
          </div>
        </div>

        <div className="bg-white border border-gray-200 rounded-2xl p-5 shadow-md">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-gray-500 text-sm">Total Revenue</p>
              <h3 className="text-3xl font-bold text-green-600 mt-1">₹{stats.totalRevenue.toLocaleString()}</h3>
            </div>
            <div className="w-12 h-12 rounded-xl bg-green-100 flex items-center justify-center text-2xl">R</div>
          </div>
        </div>

        <div className="bg-white border border-gray-200 rounded-2xl p-5 shadow-md">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-gray-500 text-sm">Pending Orders</p>
              <h3 className="text-3xl font-bold text-yellow-600 mt-1">{stats.pendingOrders}</h3>
            </div>
            <div className="w-12 h-12 rounded-xl bg-yellow-100 flex items-center justify-center text-2xl">P</div>
          </div>
        </div>

        <div className="bg-white border border-gray-200 rounded-2xl p-5 shadow-md">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-gray-500 text-sm">Delivered Orders</p>
              <h3 className="text-3xl font-bold text-blue-600 mt-1">{stats.deliveredOrders}</h3>
            </div>
            <div className="w-12 h-12 rounded-xl bg-blue-100 flex items-center justify-center text-2xl">D</div>
          </div>
        </div>
      </div>

      {/* Quick Navigation */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <div className="bg-white border border-gray-200 rounded-2xl p-6 shadow-md">
          <h3 className="text-lg font-bold text-gray-800 mb-4">Order Status</h3>
          <div className="space-y-3">
            <button onClick={() => navigate("/orders/new")} className="w-full text-left px-4 py-2 bg-gray-50 rounded-xl hover:bg-gray-100">
              New Orders → <span className="text-orange-500">12</span>
            </button>
            <button onClick={() => navigate("/orders/processing")} className="w-full text-left px-4 py-2 bg-gray-50 rounded-xl hover:bg-gray-100">
              Processing → <span className="text-blue-500">24</span>
            </button>
            <button onClick={() => navigate("/orders/completed")} className="w-full text-left px-4 py-2 bg-gray-50 rounded-xl hover:bg-gray-100">
              Completed → <span className="text-green-500">892</span>
            </button>
            <button onClick={() => navigate("/orders/cancelled")} className="w-full text-left px-4 py-2 bg-gray-50 rounded-xl hover:bg-gray-100">
              Cancelled → <span className="text-red-500">45</span>
            </button>
            <button onClick={() => navigate("/orders/returns")} className="w-full text-left px-4 py-2 bg-gray-50 rounded-xl hover:bg-gray-100">
              Returns → <span className="text-purple-500">8</span>
            </button>
          </div>
        </div>

        <div className="bg-white border border-gray-200 rounded-2xl p-6 shadow-md">
          <h3 className="text-lg font-bold text-gray-800 mb-4">Quick Actions</h3>
          <div className="space-y-3">
            <button className="w-full bg-gradient-to-r from-orange-500 to-red-500 text-white py-2 rounded-xl">Export Orders</button>
            <button className="w-full bg-gray-100 text-gray-800 py-2 rounded-xl">Generate Invoice</button>
            <button className="w-full bg-gray-100 text-gray-800 py-2 rounded-xl">Bulk Update</button>
          </div>
        </div>

        <div className="bg-white border border-gray-200 rounded-2xl p-6 shadow-md">
          <h3 className="text-lg font-bold text-gray-800 mb-4">Today's Summary</h3>
          <div className="space-y-2">
            <div className="flex justify-between"><span>New Orders:</span><span className="font-bold">24</span></div>
            <div className="flex justify-between"><span>Revenue:</span><span className="font-bold text-green-600">₹45,280</span></div>
            <div className="flex justify-between"><span>Pending:</span><span className="font-bold text-orange-600">18</span></div>
            <div className="flex justify-between"><span>Delivered:</span><span className="font-bold text-blue-600">32</span></div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Orders;