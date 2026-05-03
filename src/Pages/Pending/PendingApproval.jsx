import React, { useState } from "react";

function PendingApproval() {
  const [searchTerm, setSearchTerm] = useState("");
  const [filterType, setFilterType] = useState("All");
  const [pendingItems, setPendingItems] = useState([
    { id: 1, type: "Recipe", title: "Butter Chicken", submittedBy: "Chef Ahmad", date: "2026-05-02", priority: "High" },
    { id: 2, type: "Video", title: "Quick Cooking Tips", submittedBy: "Content Team", date: "2026-05-01", priority: "Medium" },
    { id: 3, type: "Recipe", title: "Hyderabadi Biryani", submittedBy: "Chef Salman", date: "2026-05-01", priority: "High" },
    { id: 4, type: "Product", title: "Racha Ruchi Masala", submittedBy: "Admin", date: "2026-04-30", priority: "Low" },
    { id: 5, type: "Video", title: "Mastering Indian Spices", submittedBy: "Chef Priya", date: "2026-04-29", priority: "High" },
  ]);

  const handleApprove = (id) => {
    alert(`Item ${id} approved`);
  };

  const handleReject = (id) => {
    alert(`Item ${id} rejected`);
  };

  const handlePreview = (item) => {
    alert(`Previewing: ${item.title}`);
  };

  const getPriorityBadge = (priority) => {
    const colors = {
      High: "bg-red-100 text-red-800",
      Medium: "bg-yellow-100 text-yellow-800",
      Low: "bg-green-100 text-green-800",
    };
    return <span className={`px-2 py-1 rounded-full text-xs font-medium ${colors[priority]}`}>{priority}</span>;
  };

  const getTypeBadge = (type) => {
    const colors = {
      Recipe: "bg-blue-100 text-blue-800",
      Video: "bg-pink-100 text-pink-800",
      Product: "bg-purple-100 text-purple-800",
    };
    return <span className={`px-2 py-1 rounded-full text-xs font-medium ${colors[type]}`}>{type}</span>;
  };

  const filteredItems = pendingItems.filter(item => {
    const matchesSearch = item.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          item.submittedBy.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesType = filterType === "All" || item.type === filterType;
    return matchesSearch && matchesType;
  });

  return (
    <div className="min-h-screen bg-gradient-to-br from-orange-50 via-red-50 to-amber-50">
      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-6 sm:mb-8">
          <h2 className="text-2xl sm:text-3xl font-bold text-gray-800 mb-2">Pending Approvals</h2>
          <p className="text-sm sm:text-base text-gray-500">Content waiting for approval</p>
        </div>

        {/* Filters */}
        <div className="bg-white border border-gray-200 rounded-2xl p-4 sm:p-5 mb-6 shadow-md">
          <div className="flex flex-col sm:flex-row gap-4">
            <div className="flex-1">
              <input
                type="text"
                placeholder="Search by title or submitter..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full px-4 py-2 sm:py-3 border border-gray-300 rounded-xl focus:outline-none focus:border-orange-500 text-sm sm:text-base"
              />
            </div>
            <select
              value={filterType}
              onChange={(e) => setFilterType(e.target.value)}
              className="px-4 py-2 sm:py-3 border border-gray-300 rounded-xl focus:outline-none focus:border-orange-500 text-sm sm:text-base"
            >
              <option value="All">All Types</option>
              <option value="Recipe">Recipes</option>
              <option value="Video">Videos</option>
              <option value="Product">Products</option>
            </select>
          </div>
        </div>

        {/* Items Grid - Responsive */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-4 sm:gap-6">
          {filteredItems.map(item => (
            <div key={item.id} className="bg-white border border-gray-200 rounded-2xl p-4 sm:p-5 shadow-md hover:shadow-lg transition-all">
              <div className="flex flex-col sm:flex-row sm:items-start sm:justify-between gap-4">
                <div className="flex-1">
                  <div className="flex items-center gap-2 mb-2 flex-wrap">
                    {getTypeBadge(item.type)}
                    {getPriorityBadge(item.priority)}
                  </div>
                  <h3 className="text-base sm:text-lg font-bold text-gray-800 mb-1">{item.title}</h3>
                  <p className="text-xs sm:text-sm text-gray-500 mt-1">Submitted by {item.submittedBy} • {item.date}</p>
                </div>
                <div className="flex gap-2">
                  <button 
                    onClick={() => handlePreview(item)} 
                    className="flex-1 sm:flex-none px-3 py-2 bg-blue-100 text-blue-700 rounded-lg text-sm hover:bg-blue-200 transition-all"
                  >
                    Preview
                  </button>
                  <button 
                    onClick={() => handleApprove(item.id)} 
                    className="flex-1 sm:flex-none px-3 py-2 bg-green-100 text-green-700 rounded-lg text-sm hover:bg-green-200 transition-all"
                  >
                    Approve
                  </button>
                  <button 
                    onClick={() => handleReject(item.id)} 
                    className="flex-1 sm:flex-none px-3 py-2 bg-red-100 text-red-700 rounded-lg text-sm hover:bg-red-200 transition-all"
                  >
                    Reject
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>

        {filteredItems.length === 0 && (
          <div className="bg-white border border-gray-200 rounded-2xl p-8 sm:p-12 text-center">
            <div className="text-4xl sm:text-6xl mb-4">✓</div>
            <h3 className="text-lg sm:text-xl font-semibold text-gray-800 mb-2">No pending approvals</h3>
            <p className="text-sm sm:text-base text-gray-500">All content has been reviewed</p>
          </div>
        )}
      </div>
    </div>
  );
}

export default PendingApproval;