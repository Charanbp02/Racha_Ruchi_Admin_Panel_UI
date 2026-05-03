import React, { useState } from "react";
import { Search, Eye, Edit, Trash2, Film, Clock, TrendingUp, Heart, Play } from "lucide-react";

function AllShorts() {
  const [searchTerm, setSearchTerm] = useState("");
  const [filterCategory, setFilterCategory] = useState("all");

  const [shorts, setShorts] = useState([
    { id: 1, title: "Quick Paneer Recipe in 60 Seconds", category: "Cooking", views: 12450, likes: 2340, duration: "0:60", status: "Published", date: "2026-05-01" },
    { id: 2, title: "Kitchen Hack - Onion Cutting Trick", category: "Tips", views: 34210, likes: 5670, duration: "0:45", status: "Published", date: "2026-04-30" },
    { id: 3, title: "Perfect Chai Recipe", category: "Beverages", views: 28900, likes: 4560, duration: "0:50", status: "Published", date: "2026-04-29" },
    { id: 4, title: "5 Minutes Breakfast Ideas", category: "Breakfast", views: 43210, likes: 7890, duration: "0:55", status: "Published", date: "2026-04-28" },
    { id: 5, title: "Kitchen Organization Tips", category: "Tips", views: 9870, likes: 1230, duration: "0:40", status: "Draft", date: "2026-04-27" },
  ]);

  const categories = ["all", "Cooking", "Tips", "Beverages", "Breakfast", "Dessert", "Health"];

  const filteredShorts = shorts.filter(short => {
    const matchesSearch = short.title.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesCategory = filterCategory === "all" || short.category === filterCategory;
    return matchesSearch && matchesCategory;
  });

  const getStatusBadge = (status) => {
    return status === "Published" 
      ? "bg-green-100 text-green-700" 
      : "bg-yellow-100 text-yellow-700";
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-8">
          <h1 className="text-3xl lg:text-4xl font-bold bg-gradient-to-r from-blue-600 to-cyan-600 bg-clip-text text-transparent">
            All Shorts
          </h1>
          <p className="text-gray-500 mt-2">View and manage all short video content</p>
        </div>

        {/* Filters */}
        <div className="bg-white rounded-2xl p-5 mb-6 shadow-sm">
          <div className="flex flex-col md:flex-row gap-4">
            <div className="flex-1 relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                type="text"
                placeholder="Search shorts..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-10 pr-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
            <select
              value={filterCategory}
              onChange={(e) => setFilterCategory(e.target.value)}
              className="px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white"
            >
              {categories.map(cat => (
                <option key={cat} value={cat}>{cat === "all" ? "All Categories" : cat}</option>
              ))}
            </select>
          </div>
        </div>

        {/* Desktop Table View */}
        <div className="hidden lg:block bg-white rounded-2xl overflow-hidden shadow-sm">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600">Title</th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600">Category</th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600">Duration</th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600">Views</th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600">Likes</th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600">Status</th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {filteredShorts.map(short => (
                  <tr key={short.id} className="hover:bg-gray-50 transition-all">
                    <td className="px-6 py-4 font-medium text-gray-800">{short.title}</td>
                    <td className="px-6 py-4 text-gray-600">{short.category}</td>
                    <td className="px-6 py-4 text-gray-600">{short.duration}</td>
                    <td className="px-6 py-4 text-gray-600">{short.views.toLocaleString()}</td>
                    <td className="px-6 py-4 text-gray-600">{short.likes.toLocaleString()}</td>
                    <td className="px-6 py-4">
                      <span className={`px-2 py-1 rounded-full text-xs font-medium ${getStatusBadge(short.status)}`}>
                        {short.status}
                      </span>
                    </td>
                    <td className="px-6 py-4">
                      <div className="flex gap-2">
                        <button className="p-2 text-blue-600 hover:bg-blue-50 rounded-lg">
                          <Play className="w-4 h-4" />
                        </button>
                        <button className="p-2 text-green-600 hover:bg-green-50 rounded-lg">
                          <Edit className="w-4 h-4" />
                        </button>
                        <button className="p-2 text-red-600 hover:bg-red-50 rounded-lg">
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* Mobile Card View */}
        <div className="lg:hidden space-y-4">
          {filteredShorts.map(short => (
            <div key={short.id} className="bg-white rounded-2xl p-4 shadow-sm">
              <div className="flex items-start justify-between mb-3">
                <div>
                  <h3 className="font-bold text-gray-800">{short.title}</h3>
                  <p className="text-sm text-gray-500 mt-1">{short.category}</p>
                </div>
                <span className={`px-2 py-1 rounded-full text-xs font-medium ${getStatusBadge(short.status)}`}>
                  {short.status}
                </span>
              </div>
              <div className="space-y-2 mb-3">
                <div className="flex justify-between text-sm">
                  <span className="text-gray-500">Duration:</span>
                  <span className="text-gray-700">{short.duration}</span>
                </div>
                <div className="flex justify-between text-sm">
                  <span className="text-gray-500">Views:</span>
                  <span className="text-gray-700">{short.views.toLocaleString()}</span>
                </div>
                <div className="flex justify-between text-sm">
                  <span className="text-gray-500">Likes:</span>
                  <span className="text-gray-700">{short.likes.toLocaleString()}</span>
                </div>
              </div>
              <div className="flex gap-2 pt-2 border-t border-gray-100">
                <button className="flex-1 py-2 bg-blue-50 text-blue-600 rounded-lg text-sm flex items-center justify-center gap-1">
                  <Play className="w-4 h-4" />
                  Watch
                </button>
                <button className="flex-1 py-2 bg-red-50 text-red-600 rounded-lg text-sm flex items-center justify-center gap-1">
                  <Trash2 className="w-4 h-4" />
                  Delete
                </button>
              </div>
            </div>
          ))}
        </div>

        {filteredShorts.length === 0 && (
          <div className="bg-white rounded-2xl p-12 text-center">
            <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Film className="w-8 h-8 text-gray-400" />
            </div>
            <h3 className="text-xl font-semibold text-gray-800 mb-2">No shorts found</h3>
            <p className="text-gray-500">Try adjusting your search or filter criteria</p>
          </div>
        )}
      </div>
    </div>
  );
}

export default AllShorts;