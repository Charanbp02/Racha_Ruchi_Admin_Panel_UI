import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Video, Plus, Layers, TrendingUp, Clock, Film, Upload, List, Tag } from "lucide-react";

function Videos() {
  const navigate = useNavigate();

  const stats = {
    totalVideos: 248,
    popularVideos: 45,
    pendingRequests: 18,
    categories: 8,
    totalViews: 125800
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-8">
          <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
            <div>
              <h1 className="text-3xl lg:text-4xl font-bold bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent">
                Video Management
              </h1>
              <p className="text-gray-500 mt-2">Manage cooking videos, tutorials and culinary content</p>
            </div>
            <button 
              onClick={() => navigate("/videos/upload")}
              className="px-6 py-3 bg-gradient-to-r from-purple-500 to-pink-600 text-white rounded-xl font-medium hover:shadow-lg transition-all flex items-center gap-2"
            >
              <Upload className="w-5 h-5" />
              Upload New Video
            </button>
          </div>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-2 lg:grid-cols-5 gap-4 mb-8">
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-xs">Total Videos</p>
                <p className="text-2xl font-bold text-gray-800">{stats.totalVideos}</p>
              </div>
              <div className="w-10 h-10 bg-purple-100 rounded-xl flex items-center justify-center">
                <Video className="w-5 h-5 text-purple-600" />
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
                <TrendingUp className="w-5 h-5 text-green-600" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-xs">Categories</p>
                <p className="text-2xl font-bold text-blue-600">{stats.categories}</p>
              </div>
              <div className="w-10 h-10 bg-blue-100 rounded-xl flex items-center justify-center">
                <Layers className="w-5 h-5 text-blue-600" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-xs">Popular Videos</p>
                <p className="text-2xl font-bold text-orange-600">{stats.popularVideos}</p>
              </div>
              <div className="w-10 h-10 bg-orange-100 rounded-xl flex items-center justify-center">
                <TrendingUp className="w-5 h-5 text-orange-600" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-xs">Pending Requests</p>
                <p className="text-2xl font-bold text-yellow-600">{stats.pendingRequests}</p>
              </div>
              <div className="w-10 h-10 bg-yellow-100 rounded-xl flex items-center justify-center">
                <Clock className="w-5 h-5 text-yellow-600" />
              </div>
            </div>
          </div>
        </div>

        {/* Quick Navigation Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all">
            <div className="flex items-center gap-4 mb-4">
              <div className="w-12 h-12 bg-purple-100 rounded-xl flex items-center justify-center">
                <List className="w-6 h-6 text-purple-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-800">All Videos</h3>
            </div>
            <p className="text-gray-500 text-sm mb-4">View and manage all videos</p>
            <button 
              onClick={() => navigate("/videos/all")}
              className="w-full py-2 bg-purple-100 text-purple-700 rounded-xl font-medium hover:bg-purple-200 transition-all"
            >
              View All Videos
            </button>
          </div>

          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all">
            <div className="flex items-center gap-4 mb-4">
              <div className="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center">
                <Upload className="w-6 h-6 text-green-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-800">Upload Video</h3>
            </div>
            <p className="text-gray-500 text-sm mb-4">Upload new cooking videos</p>
            <button 
              onClick={() => navigate("/videos/upload")}
              className="w-full py-2 bg-green-100 text-green-700 rounded-xl font-medium hover:bg-green-200 transition-all"
            >
              Upload New Video
            </button>
          </div>

          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all">
            <div className="flex items-center gap-4 mb-4">
              <div className="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
                <Layers className="w-6 h-6 text-blue-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-800">Video Categories</h3>
            </div>
            <p className="text-gray-500 text-sm mb-4">Organize videos by categories</p>
            <button 
              onClick={() => navigate("/videos/categories")}
              className="w-full py-2 bg-blue-100 text-blue-700 rounded-xl font-medium hover:bg-blue-200 transition-all"
            >
              Manage Categories
            </button>
          </div>

          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all">
            <div className="flex items-center gap-4 mb-4">
              <div className="w-12 h-12 bg-orange-100 rounded-xl flex items-center justify-center">
                <TrendingUp className="w-6 h-6 text-orange-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-800">Popular Videos</h3>
            </div>
            <p className="text-gray-500 text-sm mb-4">Most viewed and liked videos</p>
            <button 
              onClick={() => navigate("/videos/popular")}
              className="w-full py-2 bg-orange-100 text-orange-700 rounded-xl font-medium hover:bg-orange-200 transition-all"
            >
              View Popular
            </button>
          </div>

          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all">
            <div className="flex items-center gap-4 mb-4">
              <div className="w-12 h-12 bg-yellow-100 rounded-xl flex items-center justify-center">
                <Clock className="w-6 h-6 text-yellow-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-800">Video Requests</h3>
            </div>
            <p className="text-gray-500 text-sm mb-4">Customer video requests</p>
            <button 
              onClick={() => navigate("/videos/requests")}
              className="w-full py-2 bg-yellow-100 text-yellow-700 rounded-xl font-medium hover:bg-yellow-200 transition-all"
            >
              View Requests
            </button>
          </div>

          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all">
            <div className="flex items-center gap-4 mb-4">
              <div className="w-12 h-12 bg-pink-100 rounded-xl flex items-center justify-center">
                <Tag className="w-6 h-6 text-pink-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-800">Video Tags</h3>
            </div>
            <p className="text-gray-500 text-sm mb-4">Manage video tags and labels</p>
            <button 
              onClick={() => navigate("/videos/tags")}
              className="w-full py-2 bg-pink-100 text-pink-700 rounded-xl font-medium hover:bg-pink-200 transition-all"
            >
              Manage Tags
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Videos;