import React, { useState } from "react";
import { Search, Eye, TrendingUp, Heart, Clock, Play } from "lucide-react";

function PopularVideos() {
  const [searchTerm, setSearchTerm] = useState("");
  const [filterCategory, setFilterCategory] = useState("all");

  const [popularVideos, setPopularVideos] = useState([
    { id: 1, title: "Butter Chicken - Cooking Tutorial", views: 12450, likes: 2340, duration: "8:30", category: "Dinner", trending: "Day" },
    { id: 2, title: "Hyderabadi Biryani Masterclass", views: 28900, likes: 4560, duration: "15:20", category: "Lunch", trending: "Week" },
    { id: 3, title: "Mastering Indian Spices Guide", views: 43210, likes: 7890, duration: "12:45", category: "Educational", trending: "Month" },
    { id: 4, title: "Paneer Tikka - Grilling Tips", views: 9870, likes: 1230, duration: "6:15", category: "Appetizer", trending: "Week" },
    { id: 5, title: "Quick Cooking Tips Episode 1", views: 34210, likes: 5670, duration: "5:30", category: "Tutorial", trending: "Day" },
  ]);

  const categories = ["all", "Breakfast", "Lunch", "Dinner", "Appetizer", "Dessert", "Tutorial", "Educational"];

  const filteredVideos = popularVideos.filter(video => {
    const matchesSearch = video.title.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesCategory = filterCategory === "all" || video.category === filterCategory;
    return matchesSearch && matchesCategory;
  });

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-8">
          <h1 className="text-3xl lg:text-4xl font-bold bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent">
            Popular Videos
          </h1>
          <p className="text-gray-500 mt-2">Most viewed and trending video content</p>
        </div>

        {/* Filters */}
        <div className="bg-white rounded-2xl p-5 mb-6 shadow-sm">
          <div className="flex flex-col md:flex-row gap-4">
            <div className="flex-1 relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                type="text"
                placeholder="Search popular videos..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-10 pr-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-purple-500"
              />
            </div>
            <select
              value={filterCategory}
              onChange={(e) => setFilterCategory(e.target.value)}
              className="px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-purple-500 bg-white"
            >
              {categories.map(cat => (
                <option key={cat} value={cat}>{cat === "all" ? "All Categories" : cat}</option>
              ))}
            </select>
          </div>
        </div>

        {/* Trending Stats */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
          <div className="bg-gradient-to-r from-purple-50 to-pink-50 rounded-2xl p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">Trending Today</p>
                <p className="text-2xl font-bold text-purple-600">46.7K+ views</p>
              </div>
              <TrendingUp className="w-8 h-8 text-purple-500" />
            </div>
          </div>
          <div className="bg-gradient-to-r from-pink-50 to-orange-50 rounded-2xl p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">This Week</p>
                <p className="text-2xl font-bold text-pink-600">128.2K+ views</p>
              </div>
              <TrendingUp className="w-8 h-8 text-pink-500" />
            </div>
          </div>
          <div className="bg-gradient-to-r from-orange-50 to-red-50 rounded-2xl p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">This Month</p>
                <p className="text-2xl font-bold text-orange-600">489.5K+ views</p>
              </div>
              <TrendingUp className="w-8 h-8 text-orange-500" />
            </div>
          </div>
        </div>

        {/* Popular Videos Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {filteredVideos.map(video => (
            <div key={video.id} className="bg-white rounded-2xl p-5 shadow-sm border border-gray-100 hover:shadow-md transition-all">
              <div className="flex items-start gap-4 mb-3">
                <div className="w-20 h-20 bg-gradient-to-br from-purple-400 to-pink-500 rounded-xl flex items-center justify-center flex-shrink-0">
                  <Play className="w-8 h-8 text-white" />
                </div>
                <div className="flex-1">
                  <h3 className="font-bold text-gray-800 text-lg">{video.title}</h3>
                  <span className="inline-block px-2 py-0.5 bg-gray-100 text-gray-600 rounded-full text-xs mt-1">
                    {video.category}
                  </span>
                </div>
                <span className="px-2 py-1 bg-red-100 text-red-600 rounded-full text-xs font-medium">
                  Trending
                </span>
              </div>
              <div className="flex items-center gap-4 mb-3">
                <div className="flex items-center gap-1 text-gray-500">
                  <Eye className="w-4 h-4" />
                  <span className="text-sm">{video.views.toLocaleString()}</span>
                </div>
                <div className="flex items-center gap-1 text-gray-500">
                  <Heart className="w-4 h-4" />
                  <span className="text-sm">{video.likes.toLocaleString()}</span>
                </div>
                <div className="flex items-center gap-1 text-gray-500">
                  <Clock className="w-4 h-4" />
                  <span className="text-sm">{video.duration}</span>
                </div>
              </div>
              <button className="w-full py-2 bg-gradient-to-r from-purple-500 to-pink-600 text-white rounded-xl font-medium hover:shadow-lg transition-all flex items-center justify-center gap-2">
                <Play className="w-4 h-4" />
                Watch Video
              </button>
            </div>
          ))}
        </div>

        {filteredVideos.length === 0 && (
          <div className="bg-white rounded-2xl p-12 text-center">
            <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Video className="w-8 h-8 text-gray-400" />
            </div>
            <h3 className="text-xl font-semibold text-gray-800 mb-2">No videos found</h3>
            <p className="text-gray-500">Try adjusting your search or filter criteria</p>
          </div>
        )}
      </div>
    </div>
  );
}

export default PopularVideos;