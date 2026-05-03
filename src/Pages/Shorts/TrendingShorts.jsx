import React, { useState } from "react";
import { Search, Eye, TrendingUp, Heart, Clock, Play, Flame } from "lucide-react";

function TrendingShorts() {
  const [searchTerm, setSearchTerm] = useState("");
  const [filterCategory, setFilterCategory] = useState("all");

  const [trendingShorts, setTrendingShorts] = useState([
    { id: 1, title: "Quick Paneer Tikka", views: 12450, likes: 2340, duration: "0:45", category: "Cooking", trending: "Day", growth: "+25%" },
    { id: 2, title: "Kitchen Hack - Onion Cutting", views: 34210, likes: 5670, duration: "0:30", category: "Tips", trending: "Week", growth: "+45%" },
    { id: 3, title: "5 Minute Breakfast", views: 28900, likes: 4560, duration: "0:60", category: "Quick Recipes", trending: "Week", growth: "+32%" },
    { id: 4, title: "Secret Spice Mix", views: 43210, likes: 7890, duration: "0:25", category: "Tips", trending: "Month", growth: "+18%" },
    { id: 5, title: "Restaurant Style Curry", views: 9870, likes: 1230, duration: "0:50", category: "Cooking", trending: "Day", growth: "+67%" },
  ]);

  const categories = ["all", "Cooking", "Tips", "Quick Recipes", "Healthy", "Desserts"];

  const filteredShorts = trendingShorts.filter(short => {
    const matchesSearch = short.title.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesCategory = filterCategory === "all" || short.category === filterCategory;
    return matchesSearch && matchesCategory;
  });

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-8">
          <h1 className="text-3xl lg:text-4xl font-bold bg-gradient-to-r from-blue-600 to-cyan-600 bg-clip-text text-transparent">
            Trending Shorts
          </h1>
          <p className="text-gray-500 mt-2">Most viewed and trending short videos</p>
        </div>

        {/* Filters */}
        <div className="bg-white rounded-2xl p-5 mb-6 shadow-sm">
          <div className="flex flex-col md:flex-row gap-4">
            <div className="flex-1 relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                type="text"
                placeholder="Search trending shorts..."
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

        {/* Trending Stats */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
          <div className="bg-gradient-to-r from-blue-50 to-cyan-50 rounded-2xl p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">Trending Today</p>
                <p className="text-2xl font-bold text-blue-600">46.7K+ views</p>
              </div>
              <Flame className="w-8 h-8 text-blue-500" />
            </div>
          </div>
          <div className="bg-gradient-to-r from-cyan-50 to-teal-50 rounded-2xl p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">This Week</p>
                <p className="text-2xl font-bold text-cyan-600">128.2K+ views</p>
              </div>
              <TrendingUp className="w-8 h-8 text-cyan-500" />
            </div>
          </div>
          <div className="bg-gradient-to-r from-teal-50 to-green-50 rounded-2xl p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">This Month</p>
                <p className="text-2xl font-bold text-teal-600">489.5K+ views</p>
              </div>
              <TrendingUp className="w-8 h-8 text-teal-500" />
            </div>
          </div>
        </div>

        {/* Trending Shorts Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {filteredShorts.map(short => (
            <div key={short.id} className="bg-white rounded-2xl p-5 shadow-sm border border-gray-100 hover:shadow-md transition-all">
              <div className="flex items-start gap-4 mb-3">
                <div className="w-20 h-20 bg-gradient-to-br from-blue-400 to-cyan-500 rounded-xl flex items-center justify-center flex-shrink-0">
                  <Play className="w-8 h-8 text-white" />
                </div>
                <div className="flex-1">
                  <h3 className="font-bold text-gray-800 text-lg">{short.title}</h3>
                  <span className="inline-block px-2 py-0.5 bg-gray-100 text-gray-600 rounded-full text-xs mt-1">
                    {short.category}
                  </span>
                </div>
                <span className="px-2 py-1 bg-red-100 text-red-600 rounded-full text-xs font-medium flex items-center gap-1">
                  <Flame className="w-3 h-3" />
                  Trending
                </span>
              </div>
              <div className="flex items-center gap-4 mb-3">
                <div className="flex items-center gap-1 text-gray-500">
                  <Eye className="w-4 h-4" />
                  <span className="text-sm">{short.views.toLocaleString()}</span>
                </div>
                <div className="flex items-center gap-1 text-gray-500">
                  <Heart className="w-4 h-4" />
                  <span className="text-sm">{short.likes.toLocaleString()}</span>
                </div>
                <div className="flex items-center gap-1 text-gray-500">
                  <Clock className="w-4 h-4" />
                  <span className="text-sm">{short.duration}</span>
                </div>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-xs text-green-600 bg-green-50 px-2 py-1 rounded-full">
                  {short.growth} growth
                </span>
                <button className="px-4 py-2 bg-gradient-to-r from-blue-500 to-cyan-600 text-white rounded-xl text-sm font-medium hover:shadow-lg transition-all flex items-center gap-2">
                  <Play className="w-4 h-4" />
                  Watch Now
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
            <h3 className="text-xl font-semibold text-gray-800 mb-2">No trending shorts found</h3>
            <p className="text-gray-500">Try adjusting your search or filter criteria</p>
          </div>
        )}
      </div>
    </div>
  );
}

export default TrendingShorts;