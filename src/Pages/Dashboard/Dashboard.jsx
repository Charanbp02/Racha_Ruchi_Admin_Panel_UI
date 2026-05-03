import React, { useState } from "react";
import { useNavigate } from "react-router-dom";

function Dashboard() {
  const navigate = useNavigate();
  
  // State for notifications
  const [showNotification, setShowNotification] = useState(false);
  const [notificationMessage, setNotificationMessage] = useState("");

  // Navigation handlers for statistics cards - REMOVED /dashboard/ prefix
  const handleTotalVideosClick = () => {
    navigate("/total-videos");
  };

  const handlePendingApprovalsClick = () => {
    navigate("/pending-approvals");
  };

  const handleTotalUsersClick = () => {
    navigate("/total-users");
  };

  const handleTotalProductsClick = () => {
    navigate("/total-products");
  };

  const handleRecentActivityClick = () => {
    navigate("/recent-activity");
  };

  // Quick action handlers
  const handleUploadRecipe = () => {
    setNotificationMessage("Upload Recipe feature coming soon!");
    setShowNotification(true);
    setTimeout(() => setShowNotification(false), 3000);
  };

  const handleAddProduct = () => {
    setNotificationMessage("Add Product feature coming soon!");
    setShowNotification(true);
    setTimeout(() => setShowNotification(false), 3000);
  };

  const handleReviewPending = () => {
    setNotificationMessage("Redirecting to pending approvals...");
    setShowNotification(true);
    setTimeout(() => setShowNotification(false), 3000);
    // Navigate to pending approvals page after notification
    setTimeout(() => {
      navigate("/pending-approvals");
    }, 1500);
  };

  const handleViewAll = () => {
    setNotificationMessage("Redirecting to recent activity...");
    setShowNotification(true);
    setTimeout(() => setShowNotification(false), 3000);
    // Navigate to recent activity page after notification
    setTimeout(() => {
      navigate("/recent-activity");
    }, 1500);
  };

  return (
    <div className="min-h-screen">
      
      {/* Notification Toast */}
      {showNotification && (
        <div className="fixed top-20 right-4 z-50 bg-gray-800 text-white px-6 py-3 rounded-xl shadow-lg animate-bounce">
          {notificationMessage}
        </div>
      )}

      {/* Statistics Cards - Quick Review Section */}
      <div className="mb-8">
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-2xl font-bold text-gray-800">
            Quick Review
          </h2>
          <p className="text-sm text-gray-500">
            Last updated: {new Date().toLocaleTimeString()}
          </p>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-6">
          
          {/* Total Videos Card - Clickable */}
          <div 
            onClick={handleTotalVideosClick}
            className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl hover:scale-[1.02] transition-all duration-300 group cursor-pointer"
          >
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-sm font-medium">
                  Total Videos
                </p>
                <h2 className="text-4xl font-bold text-gray-800 mt-3">
                  248
                </h2>
                <div className="flex items-center gap-2 mt-3">
                  <span className="text-green-500 text-sm font-semibold">
                    +12
                  </span>
                  <span className="text-gray-400 text-xs">
                    this week
                  </span>
                </div>
              </div>
              <div className="w-16 h-16 rounded-2xl bg-orange-100 flex items-center justify-center text-3xl group-hover:bg-orange-200 transition-all">
                V
              </div>
            </div>
            {/* Progress Bar */}
            <div className="mt-4">
              <div className="bg-gray-100 rounded-full h-1.5">
                <div className="bg-orange-500 rounded-full h-1.5 w-3/4"></div>
              </div>
              <p className="text-xs text-gray-400 mt-2">75% of yearly goal</p>
            </div>
            <div className="mt-3 text-right">
              <span className="text-xs text-orange-500 opacity-0 group-hover:opacity-100 transition-opacity">
                Click to view details →
              </span>
            </div>
          </div>

          {/* Pending Approvals Card - Clickable */}
          <div 
            onClick={handlePendingApprovalsClick}
            className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl hover:scale-[1.02] transition-all duration-300 group cursor-pointer"
          >
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-sm font-medium">
                  Pending Approvals
                </p>
                <h2 className="text-4xl font-bold text-gray-800 mt-3">
                  18
                </h2>
                <div className="flex items-center gap-2 mt-3">
                  <span className="text-yellow-500 text-sm font-semibold">
                    Needs Review
                  </span>
                </div>
              </div>
              <div className="w-16 h-16 rounded-2xl bg-yellow-100 flex items-center justify-center text-3xl group-hover:bg-yellow-200 transition-all">
                P
              </div>
            </div>
            <div className="mt-4">
              <button 
                onClick={(e) => {
                  e.stopPropagation();
                  handlePendingApprovalsClick();
                }}
                className="text-yellow-600 text-xs font-medium hover:text-yellow-700"
              >
                Review now →
              </button>
            </div>
            <div className="mt-2 text-right">
              <span className="text-xs text-orange-500 opacity-0 group-hover:opacity-100 transition-opacity">
                Click to view details →
              </span>
            </div>
          </div>

          {/* Total Users Card - Clickable */}
          <div 
            onClick={handleTotalUsersClick}
            className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl hover:scale-[1.02] transition-all duration-300 group cursor-pointer"
          >
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-sm font-medium">
                  Total Users
                </p>
                <h2 className="text-4xl font-bold text-gray-800 mt-3">
                  12.5K
                </h2>
                <div className="flex items-center gap-2 mt-3">
                  <span className="text-blue-500 text-sm font-semibold">
                    +240
                  </span>
                  <span className="text-gray-400 text-xs">
                    new this month
                  </span>
                </div>
              </div>
              <div className="w-16 h-16 rounded-2xl bg-blue-100 flex items-center justify-center text-3xl group-hover:bg-blue-200 transition-all">
                U
              </div>
            </div>
            <div className="mt-4">
              <div className="flex -space-x-2">
                {[1, 2, 3, 4].map((i) => (
                  <div key={i} className="w-6 h-6 rounded-full bg-blue-500 border-2 border-white flex items-center justify-center text-white text-xs">
                    {String.fromCharCode(64 + i)}
                  </div>
                ))}
                <div className="w-6 h-6 rounded-full bg-gray-300 border-2 border-white flex items-center justify-center text-gray-600 text-xs">
                  +2K
                </div>
              </div>
            </div>
            <div className="mt-3 text-right">
              <span className="text-xs text-orange-500 opacity-0 group-hover:opacity-100 transition-opacity">
                Click to view details →
              </span>
            </div>
          </div>

          {/* Total Products Card - Clickable */}
          <div 
            onClick={handleTotalProductsClick}
            className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl hover:scale-[1.02] transition-all duration-300 group cursor-pointer"
          >
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-sm font-medium">
                  Total Products
                </p>
                <h2 className="text-4xl font-bold text-gray-800 mt-3">
                  86
                </h2>
                <div className="flex items-center gap-2 mt-3">
                  <span className="text-pink-500 text-sm font-semibold">
                    8 Low Stock
                  </span>
                </div>
              </div>
              <div className="w-16 h-16 rounded-2xl bg-pink-100 flex items-center justify-center text-3xl group-hover:bg-pink-200 transition-all">
                P
              </div>
            </div>
            <div className="mt-4">
              <div className="flex gap-1">
                {[...Array(5)].map((_, i) => (
                  <div key={i} className={`flex-1 h-1 rounded-full ${i < 2 ? 'bg-red-400' : 'bg-gray-200'}`}></div>
                ))}
              </div>
              <p className="text-xs text-gray-400 mt-2">2 products below reorder level</p>
            </div>
            <div className="mt-3 text-right">
              <span className="text-xs text-orange-500 opacity-0 group-hover:opacity-100 transition-opacity">
                Click to view details →
              </span>
            </div>
          </div>

        </div>
      </div>

      {/* Recent Activity & Quick Actions Section */}
      <div className="grid grid-cols-1 xl:grid-cols-3 gap-6">

        {/* Recent Activity - Detailed Monitoring */}
        <div className="xl:col-span-2 bg-white border border-gray-200 rounded-3xl p-6 shadow-xl">
          <div className="flex items-center justify-between mb-6">
            <div>
              <h2 className="text-2xl font-bold text-gray-800">
                Recent Activity
              </h2>
              <p className="text-gray-500 text-sm mt-1">
                Monitor latest updates and actions
              </p>
            </div>
            <button 
              onClick={handleViewAll}
              className="text-orange-500 hover:text-orange-600 text-sm font-medium transition-all"
            >
              View All →
            </button>
          </div>

          <div className="space-y-4">
            {/* Activity Item 1 - Clickable */}
            <div 
              onClick={() => navigate("/recent-activity")}
              className="flex items-center justify-between bg-gray-50 rounded-2xl p-4 hover:bg-gray-100 transition-all cursor-pointer"
            >
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-full bg-green-100 flex items-center justify-center text-xl">
                  V
                </div>
                <div>
                  <h3 className="text-gray-800 font-medium">
                    New Recipe Uploaded
                  </h3>
                  <p className="text-gray-500 text-sm mt-0.5">
                    Chicken Biryani Recipe Added by Chef Ahmad
                  </p>
                </div>
              </div>
              <div className="text-right">
                <span className="text-gray-400 text-sm">
                  2 min ago
                </span>
                <span className="block text-green-500 text-xs font-medium mt-1">
                  Pending Review
                </span>
              </div>
            </div>

            {/* Activity Item 2 - Clickable */}
            <div 
              onClick={() => navigate("/recent-activity")}
              className="flex items-center justify-between bg-gray-50 rounded-2xl p-4 hover:bg-gray-100 transition-all cursor-pointer"
            >
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-full bg-purple-100 flex items-center justify-center text-xl">
                  P
                </div>
                <div>
                  <h3 className="text-gray-800 font-medium">
                    New Product Added
                  </h3>
                  <p className="text-gray-500 text-sm mt-0.5">
                    Racha Ruchi Masala Powder - Premium Edition
                  </p>
                </div>
              </div>
              <div className="text-right">
                <span className="text-gray-400 text-sm">
                  10 min ago
                </span>
                <span className="block text-blue-500 text-xs font-medium mt-1">
                  Approved
                </span>
              </div>
            </div>

            {/* Activity Item 3 - Clickable */}
            <div 
              onClick={() => navigate("/recent-activity")}
              className="flex items-center justify-between bg-gray-50 rounded-2xl p-4 hover:bg-gray-100 transition-all cursor-pointer"
            >
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center text-xl">
                  U
                </div>
                <div>
                  <h3 className="text-gray-800 font-medium">
                    User Registered
                  </h3>
                  <p className="text-gray-500 text-sm mt-0.5">
                    24 New Users Joined this hour
                  </p>
                </div>
              </div>
              <div className="text-right">
                <span className="text-gray-400 text-sm">
                  1 hour ago
                </span>
                <span className="block text-green-500 text-xs font-medium mt-1">
                  Active
                </span>
              </div>
            </div>

            {/* Activity Item 4 - Clickable */}
            <div 
              onClick={() => navigate("/recent-activity")}
              className="flex items-center justify-between bg-gray-50 rounded-2xl p-4 hover:bg-gray-100 transition-all cursor-pointer"
            >
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-full bg-yellow-100 flex items-center justify-center text-xl">
                  R
                </div>
                <div>
                  <h3 className="text-gray-800 font-medium">
                    New Review Posted
                  </h3>
                  <p className="text-gray-500 text-sm mt-0.5">
                    5-star rating for Butter Chicken Recipe
                  </p>
                </div>
              </div>
              <div className="text-right">
                <span className="text-gray-400 text-sm">
                  3 hours ago
                </span>
                <span className="block text-yellow-500 text-xs font-medium mt-1">
                  Featured
                </span>
              </div>
            </div>

            {/* Activity Item 5 - Clickable */}
            <div 
              onClick={() => navigate("/recent-activity")}
              className="flex items-center justify-between bg-gray-50 rounded-2xl p-4 hover:bg-gray-100 transition-all cursor-pointer"
            >
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-full bg-red-100 flex items-center justify-center text-xl">
                  A
                </div>
                <div>
                  <h3 className="text-gray-800 font-medium">
                    Low Stock Alert
                  </h3>
                  <p className="text-gray-500 text-sm mt-0.5">
                    3 products running low on inventory
                  </p>
                </div>
              </div>
              <div className="text-right">
                <span className="text-gray-400 text-sm">
                  5 hours ago
                </span>
                <span className="block text-red-500 text-xs font-medium mt-1">
                  Urgent
                </span>
              </div>
            </div>

          </div>

          {/* Activity Summary */}
          <div className="mt-6 pt-4 border-t border-gray-100">
            <div className="flex justify-between text-sm">
              <span className="text-gray-500">Today's Activity: 12 updates</span>
              <button 
                onClick={() => navigate("/recent-activity")}
                className="text-orange-500 font-medium hover:text-orange-600"
              >
                View All Activity →
              </button>
            </div>
          </div>
        </div>

        {/* Quick Actions Panel */}
        <div className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl">
          <h2 className="text-2xl font-bold text-gray-800 mb-2">
            Quick Actions
          </h2>
          <p className="text-gray-500 text-sm mb-6">
            Perform common tasks efficiently
          </p>

          <div className="space-y-4">
            <button 
              onClick={handleUploadRecipe}
              className="w-full bg-gradient-to-r from-orange-500 to-red-500 hover:from-orange-600 hover:to-red-600 text-white py-4 rounded-2xl font-medium transition-all shadow-lg flex items-center justify-center gap-2"
            >
              <span className="text-xl">+</span> Upload Recipe
            </button>

            <button 
              onClick={handleAddProduct}
              className="w-full bg-gray-100 hover:bg-gray-200 text-gray-800 py-4 rounded-2xl font-medium transition-all flex items-center justify-center gap-2"
            >
              <span className="text-xl">+</span> Add Product
            </button>

            <button 
              onClick={handleReviewPending}
              className="w-full border border-orange-200 hover:bg-orange-50 text-orange-600 py-4 rounded-2xl font-medium transition-all flex items-center justify-center gap-2"
            >
              <span className="text-xl">R</span> Review Pending
            </button>
          </div>

          {/* Quick Stats */}
          <div className="mt-6 p-4 bg-gradient-to-r from-orange-50 to-red-50 rounded-2xl">
            <h3 className="text-sm font-semibold text-gray-700 mb-2">
              Today's Summary
            </h3>
            <div className="space-y-2 text-sm">
              <div className="flex justify-between">
                <span className="text-gray-600">New Orders:</span>
                <span className="font-semibold text-gray-800">24</span>
              </div>
              <div className="flex justify-between">
                <span className="text-gray-600">Revenue:</span>
                <span className="font-semibold text-green-600">₹45,280</span>
              </div>
              <div className="flex justify-between">
                <span className="text-gray-600">Pending Tasks:</span>
                <span className="font-semibold text-orange-600">8</span>
              </div>
            </div>
          </div>

          {/* Navigation Help */}
          <div className="mt-4 pt-3 border-t border-gray-100">
            <p className="text-xs text-gray-400 text-center">
              Click on any statistic card to view detailed page
            </p>
          </div>
        </div>

      </div>
    </div>
  );
}

export default Dashboard;