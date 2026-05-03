import React from "react";

function PendingApprovals() {
  const pendingItems = [
    { id: 1, type: "Recipe", title: "Butter Chicken Recipe", author: "Chef Ahmad", date: "2026-05-01", status: "pending" },
    { id: 2, type: "Video", title: "Cooking Short - Paneer Tikka", author: "Chef Neha", date: "2026-05-01", status: "pending" },
    { id: 3, type: "Product", title: "Racha Ruchi Masala", author: "Admin", date: "2026-04-30", status: "pending" },
    { id: 4, type: "User", title: "New Chef Registration", author: "Rajesh Kumar", date: "2026-04-30", status: "pending" },
    { id: 5, type: "Review", title: "5-star Review for Biryani", author: "User123", date: "2026-04-29", status: "pending" },
  ];

  const handleApprove = (id) => {
    alert(`Item ${id} approved!`);
  };

  const handleReject = (id) => {
    alert(`Item ${id} rejected!`);
  };

  const getTypeIcon = (type) => {
    switch(type) {
      case 'Recipe': return 'R';
      case 'Video': return 'V';
      case 'Product': return 'P';
      case 'User': return 'U';
      case 'Review': return 'F';
      default: return 'I';
    }
  };

  const getTypeColor = (type) => {
    switch(type) {
      case 'Recipe': return 'bg-green-100';
      case 'Video': return 'bg-purple-100';
      case 'Product': return 'bg-pink-100';
      case 'User': return 'bg-blue-100';
      case 'Review': return 'bg-yellow-100';
      default: return 'bg-gray-100';
    }
  };

  return (
    <div className="min-h-screen">
      <div className="mb-8">
        <h2 className="text-2xl font-bold text-gray-800 mb-2">
          Pending Approvals
        </h2>
        <p className="text-gray-500">Review and approve pending content</p>
      </div>

      <div className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl">
        <div className="flex items-center justify-between mb-6">
          <h3 className="text-xl font-bold text-gray-800">
            Items Awaiting Approval ({pendingItems.length})
          </h3>
          <button className="text-orange-500 text-sm font-medium">Filter</button>
        </div>

        <div className="space-y-4">
          {pendingItems.map((item) => (
            <div key={item.id} className="flex items-center justify-between p-4 bg-gray-50 rounded-2xl hover:bg-gray-100 transition-all">
              <div className="flex items-center gap-4">
                <div className={`w-12 h-12 rounded-full flex items-center justify-center text-xl ${getTypeColor(item.type)}`}>
                  {getTypeIcon(item.type)}
                </div>
                <div>
                  <h4 className="font-medium text-gray-800">{item.title}</h4>
                  <p className="text-sm text-gray-500">
                    {item.type} • {item.author} • {item.date}
                  </p>
                </div>
              </div>
              <div className="flex gap-2">
                <button 
                  onClick={() => handleApprove(item.id)}
                  className="px-4 py-2 text-sm bg-green-500 text-white rounded-xl hover:bg-green-600 transition-all"
                >
                  Approve
                </button>
                <button 
                  onClick={() => handleReject(item.id)}
                  className="px-4 py-2 text-sm bg-red-500 text-white rounded-xl hover:bg-red-600 transition-all"
                >
                  Reject
                </button>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

export default PendingApprovals;