import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Film, Plus, Layers, TrendingUp, Clock, Upload, List, Tag, Eye, Heart } from "lucide-react";

function Shorts() {
  const navigate = useNavigate();

  const stats = {
    totalShorts: 156,
    trendingShorts: 28,
    totalViews: 245800,
    categories: 6
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-8">
          <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
            <div>
              <h1 className="text-3xl lg:text-4xl font-bold bg-gradient-to-r from-blue-600 to-cyan-600 bg-clip-text text-transparent">
                Shorts Management
              </h1>
              <p className="text-gray-500 mt-2">Manage short video content and reels</p>
            </div>
            <button 
              onClick={() => navigate("/shorts/upload")}
              className="px-6 py-3 bg-gradient-to-r from-blue-500 to-cyan-600 text-white rounded-xl font-medium hover:shadow-lg transition-all flex items-center gap-2"
            >
              <Upload className="w-5 h-5" />
              Upload Short
            </button>
          </div>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-xs">Total Shorts</p>
                <p className="text-2xl font-bold text-gray-800">{stats.totalShorts}</p>
              </div>
              <div className="w-10 h-10 bg-blue-100 rounded-xl flex items-center justify-center">
                <Film className="w-5 h-5 text-blue-600" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-xs">Total Views</p>
                <p className="text-2xl font-bold text-green-600">{stats.totalViews.toLocaleString()}</p>
              </div>
              <div className="w-10 h-10 bg-green-100 rounded-xl flex items-center justify-center">
                <Eye className="w-5 h-5 text-green-600" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-xs">Trending Shorts</p>
                <p className="text-2xl font-bold text-orange-600">{stats.trendingShorts}</p>
              </div>
              <div className="w-10 h-10 bg-orange-100 rounded-xl flex items-center justify-center">
                <TrendingUp className="w-5 h-5 text-orange-600" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-xs">Categories</p>
                <p className="text-2xl font-bold text-cyan-600">{stats.categories}</p>
              </div>
              <div className="w-10 h-10 bg-cyan-100 rounded-xl flex items-center justify-center">
                <Layers className="w-5 h-5 text-cyan-600" />
              </div>
            </div>
          </div>
        </div>

        {/* Quick Navigation Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all">
            <div className="flex items-center gap-4 mb-4">
              <div className="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
                <List className="w-6 h-6 text-blue-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-800">All Shorts</h3>
            </div>
            <p className="text-gray-500 text-sm mb-4">View and manage all shorts</p>
            <button 
              onClick={() => navigate("/shorts/all")}
              className="w-full py-2 bg-blue-100 text-blue-700 rounded-xl font-medium hover:bg-blue-200 transition-all"
            >
              View All Shorts
            </button>
          </div>

          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all">
            <div className="flex items-center gap-4 mb-4">
              <div className="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center">
                <Upload className="w-6 h-6 text-green-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-800">Upload Short</h3>
            </div>
            <p className="text-gray-500 text-sm mb-4">Upload new short videos</p>
            <button 
              onClick={() => navigate("/shorts/upload")}
              className="w-full py-2 bg-green-100 text-green-700 rounded-xl font-medium hover:bg-green-200 transition-all"
            >
              Upload Short
            </button>
          </div>

          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all">
            <div className="flex items-center gap-4 mb-4">
              <div className="w-12 h-12 bg-orange-100 rounded-xl flex items-center justify-center">
                <TrendingUp className="w-6 h-6 text-orange-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-800">Trending Shorts</h3>
            </div>
            <p className="text-gray-500 text-sm mb-4">Most viewed shorts</p>
            <button 
              onClick={() => navigate("/shorts/trending")}
              className="w-full py-2 bg-orange-100 text-orange-700 rounded-xl font-medium hover:bg-orange-200 transition-all"
            >
              View Trending
            </button>
          </div>

          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all">
            <div className="flex items-center gap-4 mb-4">
              <div className="w-12 h-12 bg-cyan-100 rounded-xl flex items-center justify-center">
                <Layers className="w-6 h-6 text-cyan-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-800">Short Categories</h3>
            </div>
            <p className="text-gray-500 text-sm mb-4">Manage short categories</p>
            <button 
              onClick={() => navigate("/shorts/categories")}
              className="w-full py-2 bg-cyan-100 text-cyan-700 rounded-xl font-medium hover:bg-cyan-200 transition-all"
            >
              Manage Categories
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Shorts;