import React, { useState } from "react";
import { Plus, Edit, Trash2, Layers, Video } from "lucide-react";

function VideoCategories() {
  const [categories, setCategories] = useState([
    { id: 1, name: "Breakfast", videoCount: 45, status: "Active" },
    { id: 2, name: "Lunch", videoCount: 38, status: "Active" },
    { id: 3, name: "Dinner", videoCount: 52, status: "Active" },
    { id: 4, name: "Appetizer", videoCount: 24, status: "Active" },
    { id: 5, name: "Dessert", videoCount: 18, status: "Active" },
    { id: 6, name: "Tutorial", videoCount: 32, status: "Active" },
    { id: 7, name: "Educational", videoCount: 12, status: "Inactive" },
  ]);
  const [showAddModal, setShowAddModal] = useState(false);
  const [newCategory, setNewCategory] = useState({ name: "" });

  const handleAddCategory = () => {
    if (newCategory.name) {
      setCategories([...categories, {
        id: categories.length + 1,
        ...newCategory,
        videoCount: 0,
        status: "Active"
      }]);
      setShowAddModal(false);
      setNewCategory({ name: "" });
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-8">
          <div>
            <h1 className="text-3xl lg:text-4xl font-bold bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent">
              Video Categories
            </h1>
            <p className="text-gray-500 mt-2">Manage video categories</p>
          </div>
          <button 
            onClick={() => setShowAddModal(true)}
            className="px-5 py-2.5 bg-gradient-to-r from-purple-500 to-pink-600 text-white rounded-xl font-medium hover:shadow-lg transition-all flex items-center gap-2"
          >
            <Plus className="w-5 h-5" />
            Add Category
          </button>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {categories.map(category => (
            <div key={category.id} className="bg-white rounded-2xl p-5 shadow-sm border border-gray-100 hover:shadow-md transition-all">
              <div className="flex items-start justify-between mb-4">
                <div className="flex items-center gap-3">
                  <div className="w-12 h-12 bg-gradient-to-br from-purple-100 to-pink-100 rounded-xl flex items-center justify-center">
                    <Video className="w-6 h-6 text-purple-600" />
                  </div>
                  <div>
                    <h3 className="font-bold text-gray-800 text-lg">{category.name}</h3>
                    <p className="text-sm text-gray-500 mt-1">{category.videoCount} videos</p>
                  </div>
                </div>
                <span className={`px-2 py-1 rounded-full text-xs font-medium ${
                  category.status === "Active" ? "bg-green-100 text-green-700" : "bg-red-100 text-red-700"
                }`}>
                  {category.status}
                </span>
              </div>
              <div className="flex gap-2 pt-3 border-t border-gray-100">
                <button className="flex-1 px-3 py-2 bg-yellow-100 text-yellow-700 rounded-lg text-sm font-medium hover:bg-yellow-200 transition-all flex items-center justify-center gap-1">
                  <Edit className="w-4 h-4" />
                  Edit
                </button>
                <button className="flex-1 px-3 py-2 bg-red-100 text-red-700 rounded-lg text-sm font-medium hover:bg-red-200 transition-all flex items-center justify-center gap-1">
                  <Trash2 className="w-4 h-4" />
                  Delete
                </button>
              </div>
            </div>
          ))}
        </div>

        {showAddModal && (
          <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
            <div className="bg-white rounded-2xl max-w-md w-full p-6">
              <h3 className="text-xl font-bold text-gray-800 mb-4">Add New Category</h3>
              <div className="space-y-4">
                <input
                  type="text"
                  placeholder="Category Name"
                  value={newCategory.name}
                  onChange={(e) => setNewCategory({ name: e.target.value })}
                  className="w-full px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-purple-500"
                />
              </div>
              <div className="flex gap-3 mt-6">
                <button onClick={() => setShowAddModal(false)} className="flex-1 px-4 py-2 border border-gray-300 rounded-xl">Cancel</button>
                <button onClick={handleAddCategory} className="flex-1 px-4 py-2 bg-gradient-to-r from-purple-500 to-pink-600 text-white rounded-xl">Add Category</button>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

export default VideoCategories;