import React from "react";

function RecentActivity() {
  const activities = [
    { id: 1, type: "recipe", action: "New Recipe Uploaded", item: "Chicken Biryani", user: "Chef Ahmad", time: "2 min ago", status: "pending" },
    { id: 2, type: "product", action: "New Product Added", item: "Racha Ruchi Masala Powder", user: "Admin", time: "10 min ago", status: "approved" },
    { id: 3, type: "user", action: "User Registered", item: "24 New Users", user: "System", time: "1 hour ago", status: "active" },
    { id: 4, type: "review", action: "New Review Posted", item: "5-star rating for Butter Chicken", user: "User123", time: "3 hours ago", status: "featured" },
    { id: 5, type: "alert", action: "Low Stock Alert", item: "3 products running low", user: "System", time: "5 hours ago", status: "urgent" },
    { id: 6, type: "order", action: "New Order Received", item: "Order ORD-1234", user: "Customer", time: "6 hours ago", status: "processing" },
    { id: 7, type: "payment", action: "Payment Received", item: "₹45,280", user: "Customer", time: "8 hours ago", status: "completed" },
  ];

  const getIcon = (type) => {
    switch(type) {
      case 'recipe': return 'R';
      case 'product': return 'P';
      case 'user': return 'U';
      case 'review': return 'F';
      case 'alert': return 'A';
      case 'order': return 'O';
      case 'payment': return 'M';
      default: return 'I';
    }
  };

  const getIconBg = (type) => {
    switch(type) {
      case 'recipe': return 'bg-green-100';
      case 'product': return 'bg-purple-100';
      case 'user': return 'bg-blue-100';
      case 'review': return 'bg-yellow-100';
      case 'alert': return 'bg-red-100';
      case 'order': return 'bg-orange-100';
      case 'payment': return 'bg-teal-100';
      default: return 'bg-gray-100';
    }
  };

  const getStatusColor = (status) => {
    switch(status) {
      case 'pending': return 'text-yellow-500';
      case 'approved': return 'text-green-500';
      case 'active': return 'text-blue-500';
      case 'featured': return 'text-purple-500';
      case 'urgent': return 'text-red-500';
      case 'processing': return 'text-orange-500';
      case 'completed': return 'text-teal-500';
      default: return 'text-gray-500';
    }
  };

  return (
    <div className="min-h-screen">
      <div className="mb-8">
        <h2 className="text-2xl font-bold text-gray-800 mb-2">
          Recent Activity
        </h2>
        <p className="text-gray-500">Monitor all platform activities and updates</p>
      </div>

      {/* Activity Feed */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2 bg-white border border-gray-200 rounded-3xl p-6 shadow-xl">
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-xl font-bold text-gray-800">Activity Feed</h3>
            <div className="flex gap-2">
              <button className="px-3 py-1 text-sm bg-gray-100 rounded-lg hover:bg-gray-200">All</button>
              <button className="px-3 py-1 text-sm bg-gray-100 rounded-lg hover:bg-gray-200">Today</button>
              <button className="px-3 py-1 text-sm bg-gray-100 rounded-lg hover:bg-gray-200">This Week</button>
            </div>
          </div>

          <div className="space-y-4">
            {activities.map((activity) => (
              <div key={activity.id} className="flex items-center justify-between p-4 bg-gray-50 rounded-2xl hover:bg-gray-100 transition-all">
                <div className="flex items-center gap-4">
                  <div className={`w-12 h-12 rounded-full ${getIconBg(activity.type)} flex items-center justify-center text-2xl font-bold`}>
                    {getIcon(activity.type)}
                  </div>
                  <div>
                    <h4 className="font-medium text-gray-800">{activity.action}</h4>
                    <p className="text-sm text-gray-500">
                      {activity.item} • {activity.user}
                    </p>
                  </div>
                </div>
                <div className="text-right">
                  <span className="text-gray-400 text-sm">{activity.time}</span>
                  <span className={`block ${getStatusColor(activity.status)} text-xs font-medium mt-1 capitalize`}>
                    {activity.status}
                  </span>
                </div>
              </div>
            ))}
          </div>

          <div className="mt-6 pt-4 border-t border-gray-100">
            <div className="flex justify-between text-sm">
              <span className="text-gray-500">Total Activities Today: 24</span>
              <button className="text-orange-500 font-medium hover:text-orange-600">
                Load More →
              </button>
            </div>
          </div>
        </div>

        {/* Activity Summary */}
        <div className="space-y-6">
          <div className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl">
            <h3 className="text-lg font-bold text-gray-800 mb-4">Activity Summary</h3>
            <div className="space-y-3">
              <div className="flex justify-between items-center">
                <span className="text-gray-600">New Recipes</span>
                <span className="font-semibold text-gray-800">12</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-gray-600">New Products</span>
                <span className="font-semibold text-gray-800">8</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-gray-600">New Users</span>
                <span className="font-semibold text-gray-800">240</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-gray-600">New Orders</span>
                <span className="font-semibold text-gray-800">45</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-gray-600">Pending Reviews</span>
                <span className="font-semibold text-yellow-600">18</span>
              </div>
            </div>
          </div>

          <div className="bg-gradient-to-br from-orange-50 to-red-50 rounded-3xl p-6 shadow-xl">
            <h3 className="text-lg font-bold text-gray-800 mb-4">Quick Stats</h3>
            <div className="space-y-3">
              <div>
                <p className="text-sm text-gray-600 mb-1">Today's Activity</p>
                <div className="w-full bg-gray-200 rounded-full h-2">
                  <div className="bg-orange-500 rounded-full h-2" style={{ width: '75%' }}></div>
                </div>
                <p className="text-xs text-gray-500 mt-1">24 out of 32 completed</p>
              </div>
              <div>
                <p className="text-sm text-gray-600 mb-1">Weekly Growth</p>
                <div className="text-2xl font-bold text-green-600">+28%</div>
                <p className="text-xs text-gray-500">compared to last week</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default RecentActivity;