import React, { useState } from "react";
import { Plus, Tag, X } from "lucide-react";

function ProductTags() {
  const [tags, setTags] = useState([
    { id: 1, name: "Organic", productCount: 56, status: "Active" },
    { id: 2, name: "Fresh", productCount: 89, status: "Active" },
    { id: 3, name: "Best Seller", productCount: 34, status: "Active" },
    { id: 4, name: "Limited Edition", productCount: 12, status: "Inactive" },
    { id: 5, name: "Seasonal", productCount: 23, status: "Active" },
  ]);
  const [newTag, setNewTag] = useState("");
  const [showAddTag, setShowAddTag] = useState(false);

  const handleAddTag = () => {
    if (newTag.trim()) {
      setTags([...tags, {
        id: tags.length + 1,
        name: newTag,
        productCount: 0,
        status: "Active"
      }]);
      setNewTag("");
      setShowAddTag(false);
    }
  };

  const handleDeleteTag = (id) => {
    setTags(tags.filter(tag => tag.id !== id));
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-8">
          <div>
            <h1 className="text-3xl lg:text-4xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
              Product Tags
            </h1>
            <p className="text-gray-500 mt-2">Manage product tags and labels</p>
          </div>
          <button 
            onClick={() => setShowAddTag(true)}
            className="px-5 py-2.5 bg-gradient-to-r from-blue-500 to-purple-600 text-white rounded-xl font-medium hover:shadow-lg transition-all flex items-center gap-2"
          >
            <Plus className="w-5 h-5" />
            Add Tag
          </button>
        </div>

        <div className="bg-white rounded-2xl p-6 shadow-sm">
          <div className="flex flex-wrap gap-3">
            {tags.map(tag => (
              <div key={tag.id} className="group relative">
                <div className={`px-4 py-2 rounded-xl flex items-center gap-2 transition-all ${
                  tag.status === "Active" 
                    ? "bg-blue-100 text-blue-700 hover:bg-blue-200" 
                    : "bg-gray-100 text-gray-500"
                }`}>
                  <Tag className="w-4 h-4" />
                  <span className="font-medium">{tag.name}</span>
                  <span className="text-xs bg-white/50 px-1.5 py-0.5 rounded-full">{tag.productCount}</span>
                  <button 
                    onClick={() => handleDeleteTag(tag.id)}
                    className="opacity-0 group-hover:opacity-100 transition-opacity ml-1"
                  >
                    <X className="w-3 h-3" />
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>

        <div className="mt-8">
          <h3 className="text-lg font-semibold text-gray-800 mb-4">Popular Tags</h3>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
            {tags.filter(t => t.productCount > 20).map(tag => (
              <div key={tag.id} className="bg-white rounded-xl p-4 shadow-sm flex items-center justify-between">
                <div>
                  <p className="font-medium text-gray-800">{tag.name}</p>
                  <p className="text-sm text-gray-500">{tag.productCount} products</p>
                </div>
                <span className="text-xs text-green-600 bg-green-100 px-2 py-1 rounded-full">Popular</span>
              </div>
            ))}
          </div>
        </div>

        {showAddTag && (
          <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
            <div className="bg-white rounded-2xl max-w-md w-full p-6">
              <h3 className="text-xl font-bold text-gray-800 mb-4">Add New Tag</h3>
              <input
                type="text"
                placeholder="Tag name"
                value={newTag}
                onChange={(e) => setNewTag(e.target.value)}
                className="w-full px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                autoFocus
              />
              <div className="flex gap-3 mt-6">
                <button onClick={() => setShowAddTag(false)} className="flex-1 px-4 py-2 border border-gray-300 rounded-xl">Cancel</button>
                <button onClick={handleAddTag} className="flex-1 px-4 py-2 bg-blue-600 text-white rounded-xl">Add Tag</button>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

export default ProductTags;