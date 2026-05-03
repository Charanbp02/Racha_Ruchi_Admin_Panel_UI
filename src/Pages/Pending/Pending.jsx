import React, { useState } from "react";
import { useNavigate } from "react-router-dom";

function Pending() {
  const navigate = useNavigate();

  const stats = {
    pendingOrders: 24,
    pendingPayments: 12,
    pendingApprovals: 18,
    pendingReviews: 45,
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-orange-50 via-red-50 to-amber-50">
      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-6 sm:mb-8">
          <h2 className="text-2xl sm:text-3xl font-bold text-gray-800 mb-2">Pending Items</h2>
          <p className="text-sm sm:text-base text-gray-500">Track all pending activities across the platform</p>
        </div>

        {/* Stats Cards - Responsive Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 sm:gap-6 mb-6 sm:mb-8">
          <div 
            onClick={() => navigate("/pending/orders")}
            className="bg-white border border-gray-200 rounded-2xl p-4 sm:p-5 shadow-md hover:shadow-lg cursor-pointer transition-all transform hover:scale-105"
          >
            <div className="flex items-center justify-between">
              <div>
                <p className="text-xs sm:text-sm text-gray-500">Pending Orders</p>
                <h3 className="text-2xl sm:text-3xl font-bold text-orange-600 mt-1">{stats.pendingOrders}</h3>
              </div>
              <div className="w-10 h-10 sm:w-12 sm:h-12 rounded-xl bg-orange-100 flex items-center justify-center text-xl sm:text-2xl">
                📦
              </div>
            </div>
          </div>

          <div 
            onClick={() => navigate("/pending/payments")}
            className="bg-white border border-gray-200 rounded-2xl p-4 sm:p-5 shadow-md hover:shadow-lg cursor-pointer transition-all transform hover:scale-105"
          >
            <div className="flex items-center justify-between">
              <div>
                <p className="text-xs sm:text-sm text-gray-500">Pending Payments</p>
                <h3 className="text-2xl sm:text-3xl font-bold text-yellow-600 mt-1">{stats.pendingPayments}</h3>
              </div>
              <div className="w-10 h-10 sm:w-12 sm:h-12 rounded-xl bg-yellow-100 flex items-center justify-center text-xl sm:text-2xl">
                💰
              </div>
            </div>
          </div>

          <div 
            onClick={() => navigate("/pending/approval")}
            className="bg-white border border-gray-200 rounded-2xl p-4 sm:p-5 shadow-md hover:shadow-lg cursor-pointer transition-all transform hover:scale-105"
          >
            <div className="flex items-center justify-between">
              <div>
                <p className="text-xs sm:text-sm text-gray-500">Pending Approvals</p>
                <h3 className="text-2xl sm:text-3xl font-bold text-purple-600 mt-1">{stats.pendingApprovals}</h3>
              </div>
              <div className="w-10 h-10 sm:w-12 sm:h-12 rounded-xl bg-purple-100 flex items-center justify-center text-xl sm:text-2xl">
                ✓
              </div>
            </div>
          </div>

          <div 
            onClick={() => navigate("/pending/reviews")}
            className="bg-white border border-gray-200 rounded-2xl p-4 sm:p-5 shadow-md hover:shadow-lg cursor-pointer transition-all transform hover:scale-105"
          >
            <div className="flex items-center justify-between">
              <div>
                <p className="text-xs sm:text-sm text-gray-500">Pending Reviews</p>
                <h3 className="text-2xl sm:text-3xl font-bold text-green-600 mt-1">{stats.pendingReviews}</h3>
              </div>
              <div className="w-10 h-10 sm:w-12 sm:h-12 rounded-xl bg-green-100 flex items-center justify-center text-xl sm:text-2xl">
                ⭐
              </div>
            </div>
          </div>
        </div>

        {/* Quick Navigation - Responsive Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <div className="bg-white border border-gray-200 rounded-2xl p-5 sm:p-6 shadow-md">
            <h3 className="text-lg sm:text-xl font-bold text-gray-800 mb-4">Quick Actions</h3>
            <div className="space-y-3">
              <button 
                onClick={() => navigate("/pending/orders")} 
                className="w-full text-left px-3 sm:px-4 py-3 bg-gray-50 rounded-xl hover:bg-gray-100 transition-all flex items-center justify-between flex-wrap gap-2"
              >
                <span className="text-sm sm:text-base">Review Pending Orders</span>
                <span className="text-orange-500 font-semibold text-sm">{stats.pendingOrders} orders</span>
              </button>
              <button 
                onClick={() => navigate("/pending/payments")} 
                className="w-full text-left px-3 sm:px-4 py-3 bg-gray-50 rounded-xl hover:bg-gray-100 transition-all flex items-center justify-between flex-wrap gap-2"
              >
                <span className="text-sm sm:text-base">Process Pending Payments</span>
                <span className="text-yellow-500 font-semibold text-sm">{stats.pendingPayments} payments</span>
              </button>
              <button 
                onClick={() => navigate("/pending/approval")} 
                className="w-full text-left px-3 sm:px-4 py-3 bg-gray-50 rounded-xl hover:bg-gray-100 transition-all flex items-center justify-between flex-wrap gap-2"
              >
                <span className="text-sm sm:text-base">Approve Content</span>
                <span className="text-purple-500 font-semibold text-sm">{stats.pendingApprovals} items</span>
              </button>
              <button 
                onClick={() => navigate("/pending/reviews")} 
                className="w-full text-left px-3 sm:px-4 py-3 bg-gray-50 rounded-xl hover:bg-gray-100 transition-all flex items-center justify-between flex-wrap gap-2"
              >
                <span className="text-sm sm:text-base">Moderate Reviews</span>
                <span className="text-green-500 font-semibold text-sm">{stats.pendingReviews} reviews</span>
              </button>
            </div>
          </div>

          <div className="bg-gradient-to-r from-orange-50 to-red-50 rounded-2xl p-5 sm:p-6 shadow-md">
            <h3 className="text-lg sm:text-xl font-bold text-gray-800 mb-4">Today's Summary</h3>
            <div className="space-y-3">
              <div className="flex justify-between items-center flex-wrap gap-2">
                <span className="text-sm sm:text-base text-gray-600">New Orders:</span>
                <span className="font-bold text-orange-600 text-lg">{stats.pendingOrders}</span>
              </div>
              <div className="flex justify-between items-center flex-wrap gap-2">
                <span className="text-sm sm:text-base text-gray-600">Pending Payments:</span>
                <span className="font-bold text-yellow-600 text-lg">{stats.pendingPayments}</span>
              </div>
              <div className="flex justify-between items-center flex-wrap gap-2">
                <span className="text-sm sm:text-base text-gray-600">Awaiting Approval:</span>
                <span className="font-bold text-purple-600 text-lg">{stats.pendingApprovals}</span>
              </div>
              <div className="flex justify-between items-center flex-wrap gap-2">
                <span className="text-sm sm:text-base text-gray-600">Pending Reviews:</span>
                <span className="font-bold text-green-600 text-lg">{stats.pendingReviews}</span>
              </div>
            </div>
            <div className="mt-4 pt-3 border-t border-orange-200">
              <div className="flex justify-between items-center">
                <span className="text-sm text-gray-600">Total Pending:</span>
                <span className="font-bold text-red-600 text-xl">
                  {stats.pendingOrders + stats.pendingPayments + stats.pendingApprovals + stats.pendingReviews}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Pending;