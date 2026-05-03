import React, { useState } from "react";
import { useNavigate } from "react-router-dom";

function ManageCategories() {
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState("");
  const [filterStatus, setFilterStatus] = useState("All");
  const [showNotification, setShowNotification] = useState(false);
  const [notificationMessage, setNotificationMessage] = useState("");

  const [categories, setCategories] = useState([
    { id: 1, name: "Breakfast", slug: "breakfast", description: "Morning recipes", recipeCount: 45, status: "Active", createdAt: "2024-01-15" },
    { id: 2, name: "Lunch", slug: "lunch", description: "Midday meals", recipeCount: 68, status: "Active", createdAt: "2024-01-15" },
    { id: 3, name: "Dinner", slug: "dinner", description: "Evening meals", recipeCount: 72, status: "Active", createdAt: "2024-01-15" },
    { id: 4, name: "Desserts", slug: "desserts", description: "Sweet treats", recipeCount: 34, status: "Inactive", createdAt: "2024-01-16" },
    { id: 5, name: "Snacks", slug: "snacks", description: "Quick bites", recipeCount: 52, status: "Active", createdAt: "2024-01-16" },
  ]);

  const showNotificationMessage = (message) => {
    setNotificationMessage(message);
    setShowNotification(true);
    setTimeout(() => setShowNotification(false), 3000);
  };

  const filteredCategories = categories.filter(cat => {
    const matchesSearch = cat.name.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = filterStatus === "All" || cat.status === filterStatus;
    return matchesSearch && matchesStatus;
  });

  const toggleStatus = (id) => {
    setCategories(categories.map(cat =>
      cat.id === id ? { ...cat, status: cat.status === "Active" ? "Inactive" : "Active" } : cat
    ));
    showNotificationMessage("Status updated successfully!");
  };

  const deleteCategory = (id) => {
    const category = categories.find(cat => cat.id === id);
    if (category.recipeCount > 0) {
      showNotificationMessage(`Cannot delete - has ${category.recipeCount} recipes!`);
      return;
    }
    setCategories(categories.filter(cat => cat.id !== id));
    showNotificationMessage("Category deleted successfully!");
  };

  return (
    <div className="min-h-screen">
      {showNotification && (
        <div className="fixed top-20 right-4 z-50 bg-gray-800 text-white px-6 py-3 rounded-xl shadow-lg">
          {notificationMessage}
        </div>
      )}

      <div className="mb-8">
        <h2 className="text-2xl font-bold text-gray-800 mb-2">Manage Categories</h2>
        <p className="text-gray-500">View, edit, and manage all categories</p>
      </div>

      {/* Search and Filter */}
      <div className="bg-white border border-gray-200 rounded-3xl p-5 mb-6 shadow-xl">
        <div className="flex flex-col md:flex-row gap-4">
          <div className="flex-1">
            <input
              type="text"
              placeholder="Search categories..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full px-4 py-2 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-orange-500"
            />
          </div>
          <select
            value={filterStatus}
            onChange={(e) => setFilterStatus(e.target.value)}
            className="px-4 py-2 border border-gray-300 rounded-xl focus:outline-none"
          >
            <option value="All">All Status</option>
            <option value="Active">Active</option>
            <option value="Inactive">Inactive</option>
          </select>
          <button
            onClick={() => navigate("/category/add")}
            className="px-6 py-2 bg-gradient-to-r from-orange-500 to-red-500 text-white rounded-xl font-medium"
          >
            + Add Category
          </button>
        </div>
      </div>

      {/* Categories Table */}
      <div className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl overflow-x-auto">
        <table className="w-full">
          <thead>
            <tr className="border-b border-gray-200">
              <th className="text-left py-3 px-4 text-gray-600">Name</th>
              <th className="text-left py-3 px-4 text-gray-600">Slug</th>
              <th className="text-left py-3 px-4 text-gray-600">Recipes</th>
              <th className="text-left py-3 px-4 text-gray-600">Status</th>
              <th className="text-left py-3 px-4 text-gray-600">Created</th>
              <th className="text-left py-3 px-4 text-gray-600">Actions</th>
            </tr>
          </thead>
          <tbody>
            {filteredCategories.map((cat) => (
              <tr key={cat.id} className="border-b border-gray-100 hover:bg-gray-50">
                <td className="py-3 px-4 font-medium">{cat.name}</td>
                <td className="py-3 px-4 text-gray-500 text-sm">{cat.slug}</td>
                <td className="py-3 px-4">{cat.recipeCount}</td>
                <td className="py-3 px-4">
                  <span className={`px-2 py-1 rounded-full text-xs font-medium ${
                    cat.status === "Active" ? "bg-green-100 text-green-600" : "bg-red-100 text-red-600"
                  }`}>
                    {cat.status}
                  </span>
                </td>
                <td className="py-3 px-4 text-gray-500 text-sm">{cat.createdAt}</td>
                <td className="py-3 px-4">
                  <button className="text-blue-500 hover:text-blue-600 mr-2">Edit</button>
                  <button onClick={() => toggleStatus(cat.id)} className="text-yellow-500 hover:text-yellow-600 mr-2">
                    {cat.status === "Active" ? "Disable" : "Enable"}
                  </button>
                  <button onClick={() => deleteCategory(cat.id)} className="text-red-500 hover:text-red-600">
                    Delete
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        {filteredCategories.length === 0 && (
          <div className="text-center py-8 text-gray-500">No categories found</div>
        )}
      </div>
    </div>
  );
}

export default ManageCategories;