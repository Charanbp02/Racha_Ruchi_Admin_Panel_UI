import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Package, Plus, Edit, Layers, Tag, Star, TrendingUp, AlertCircle } from "lucide-react";

function Products() {
  const navigate = useNavigate();

  const stats = {
    total: 1248,
    lowStock: 45,
    outOfStock: 12,
    categories: 24,
    totalValue: 45280
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-8">
          <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
            <div>
              <h1 className="text-3xl lg:text-4xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                Product Management
              </h1>
              <p className="text-gray-500 mt-2">Manage your grocery products, inventory and categories</p>
            </div>
            <button 
              onClick={() => navigate("/products/add")}
              className="px-6 py-3 bg-gradient-to-r from-blue-500 to-purple-600 text-white rounded-xl font-medium hover:shadow-lg transition-all flex items-center gap-2"
            >
              <Plus className="w-5 h-5" />
              Add New Product
            </button>
          </div>
        </div>

        <div className="grid grid-cols-2 lg:grid-cols-5 gap-4 mb-8">
          <div className="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-sm">Total Products</p>
                <p className="text-2xl font-bold text-gray-800 mt-1">{stats.total}</p>
              </div>
              <div className="w-10 h-10 bg-blue-100 rounded-xl flex items-center justify-center">
                <Package className="w-5 h-5 text-blue-600" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-sm">Low Stock</p>
                <p className="text-2xl font-bold text-yellow-600 mt-1">{stats.lowStock}</p>
              </div>
              <div className="w-10 h-10 bg-yellow-100 rounded-xl flex items-center justify-center">
                <AlertCircle className="w-5 h-5 text-yellow-600" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-sm">Out of Stock</p>
                <p className="text-2xl font-bold text-red-600 mt-1">{stats.outOfStock}</p>
              </div>
              <div className="w-10 h-10 bg-red-100 rounded-xl flex items-center justify-center">
                <Package className="w-5 h-5 text-red-600" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-sm">Categories</p>
                <p className="text-2xl font-bold text-purple-600 mt-1">{stats.categories}</p>
              </div>
              <div className="w-10 h-10 bg-purple-100 rounded-xl flex items-center justify-center">
                <Layers className="w-5 h-5 text-purple-600" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-500 text-sm">Total Value</p>
                <p className="text-2xl font-bold text-green-600 mt-1">Rs. {stats.totalValue.toLocaleString()}</p>
              </div>
              <div className="w-10 h-10 bg-green-100 rounded-xl flex items-center justify-center">
                <TrendingUp className="w-5 h-5 text-green-600" />
              </div>
            </div>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all">
            <div className="flex items-center gap-4 mb-4">
              <div className="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
                <Package className="w-6 h-6 text-blue-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-800">All Products</h3>
            </div>
            <p className="text-gray-500 text-sm mb-4">View and manage all your products</p>
            <button 
              onClick={() => navigate("/products/all")}
              className="w-full py-2 bg-gray-100 text-gray-700 rounded-xl font-medium hover:bg-gray-200 transition-all"
            >
              View All Products
            </button>
          </div>

          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all">
            <div className="flex items-center gap-4 mb-4">
              <div className="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center">
                <Plus className="w-6 h-6 text-green-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-800">Add Product</h3>
            </div>
            <p className="text-gray-500 text-sm mb-4">Add new products to your inventory</p>
            <button 
              onClick={() => navigate("/products/add")}
              className="w-full py-2 bg-green-100 text-green-700 rounded-xl font-medium hover:bg-green-200 transition-all"
            >
              Add New Product
            </button>
          </div>

          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all">
            <div className="flex items-center gap-4 mb-4">
              <div className="w-12 h-12 bg-yellow-100 rounded-xl flex items-center justify-center">
                <Edit className="w-6 h-6 text-yellow-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-800">Edit Products</h3>
            </div>
            <p className="text-gray-500 text-sm mb-4">Update product information</p>
            <button 
              onClick={() => navigate("/products/edit")}
              className="w-full py-2 bg-yellow-100 text-yellow-700 rounded-xl font-medium hover:bg-yellow-200 transition-all"
            >
              Edit Products
            </button>
          </div>

          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all">
            <div className="flex items-center gap-4 mb-4">
              <div className="w-12 h-12 bg-red-100 rounded-xl flex items-center justify-center">
                <Package className="w-6 h-6 text-red-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-800">Product Stock</h3>
            </div>
            <p className="text-gray-500 text-sm mb-4">Manage inventory and stock levels</p>
            <button 
              onClick={() => navigate("/products/stock")}
              className="w-full py-2 bg-red-100 text-red-700 rounded-xl font-medium hover:bg-red-200 transition-all"
            >
              Manage Stock
            </button>
          </div>

          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all">
            <div className="flex items-center gap-4 mb-4">
              <div className="w-12 h-12 bg-purple-100 rounded-xl flex items-center justify-center">
                <Layers className="w-6 h-6 text-purple-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-800">Product Categories</h3>
            </div>
            <p className="text-gray-500 text-sm mb-4">Organize products by categories</p>
            <button 
              onClick={() => navigate("/products/categories")}
              className="w-full py-2 bg-purple-100 text-purple-700 rounded-xl font-medium hover:bg-purple-200 transition-all"
            >
              Manage Categories
            </button>
          </div>

          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all">
            <div className="flex items-center gap-4 mb-4">
              <div className="w-12 h-12 bg-indigo-100 rounded-xl flex items-center justify-center">
                <Tag className="w-6 h-6 text-indigo-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-800">Product Tags</h3>
            </div>
            <p className="text-gray-500 text-sm mb-4">Manage product tags and labels</p>
            <button 
              onClick={() => navigate("/products/tags")}
              className="w-full py-2 bg-indigo-100 text-indigo-700 rounded-xl font-medium hover:bg-indigo-200 transition-all"
            >
              Manage Tags
            </button>
          </div>

          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all">
            <div className="flex items-center gap-4 mb-4">
              <div className="w-12 h-12 bg-pink-100 rounded-xl flex items-center justify-center">
                <Star className="w-6 h-6 text-pink-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-800">Product Reviews</h3>
            </div>
            <p className="text-gray-500 text-sm mb-4">Moderate customer reviews</p>
            <button 
              onClick={() => navigate("/products/reviews")}
              className="w-full py-2 bg-pink-100 text-pink-700 rounded-xl font-medium hover:bg-pink-200 transition-all"
            >
              View Reviews
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Products;