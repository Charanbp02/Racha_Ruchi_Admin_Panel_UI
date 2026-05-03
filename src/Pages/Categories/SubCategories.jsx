import React, { useState } from "react";
import { useNavigate } from "react-router-dom";

function SubCategories() {
  const navigate = useNavigate();
  const [showNotification, setShowNotification] = useState(false);
  const [notificationMessage, setNotificationMessage] = useState("");
  const [showAddModal, setShowAddModal] = useState(false);
  const [newSubCategory, setNewSubCategory] = useState({ name: "", parentCategory: "", description: "" });

  const [subCategories, setSubCategories] = useState([
    { id: 1, name: "Vegetarian", parentCategory: "Lunch", recipeCount: 28, status: "Active" },
    { id: 2, name: "Non-Vegetarian", parentCategory: "Dinner", recipeCount: 35, status: "Active" },
    { id: 3, name: "Vegan", parentCategory: "Breakfast", recipeCount: 12, status: "Active" },
    { id: 4, name: "Gluten Free", parentCategory: "Snacks", recipeCount: 8, status: "Inactive" },
    { id: 5, name: "Quick Meals", parentCategory: "Lunch", recipeCount: 22, status: "Active" },
  ]);

  const categories = ["Breakfast", "Lunch", "Dinner", "Desserts", "Snacks"];

  const showNotificationMessage = (message) => {
    setNotificationMessage(message);
    setShowNotification(true);
    setTimeout(() => setShowNotification(false), 3000);
  };

  const handleAddSubCategory = () => {
    if (!newSubCategory.name || !newSubCategory.parentCategory) {
      showNotificationMessage("Please fill all required fields!");
      return;
    }
    const newItem = {
      id: subCategories.length + 1,
      name: newSubCategory.name,
      parentCategory: newSubCategory.parentCategory,
      recipeCount: 0,
      status: "Active",
    };
    setSubCategories([...subCategories, newItem]);
    showNotificationMessage("Sub category added successfully!");
    setShowAddModal(false);
    setNewSubCategory({ name: "", parentCategory: "", description: "" });
  };

  const toggleStatus = (id) => {
    setSubCategories(subCategories.map(sub =>
      sub.id === id ? { ...sub, status: sub.status === "Active" ? "Inactive" : "Active" } : sub
    ));
    showNotificationMessage("Status updated!");
  };

  const deleteSubCategory = (id) => {
    setSubCategories(subCategories.filter(sub => sub.id !== id));
    showNotificationMessage("Sub category deleted!");
  };

  return (
    <div className="min-h-screen">
      {showNotification && (
        <div className="fixed top-20 right-4 z-50 bg-gray-800 text-white px-6 py-3 rounded-xl shadow-lg">
          {notificationMessage}
        </div>
      )}

      <div className="mb-8">
        <h2 className="text-2xl font-bold text-gray-800 mb-2">Sub Categories</h2>
        <p className="text-gray-500">Manage sub categories under main categories</p>
      </div>

      <div className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl">
        <div className="flex justify-between items-center mb-6">
          <h3 className="text-xl font-bold text-gray-800">Sub Category List</h3>
          <button
            onClick={() => setShowAddModal(true)}
            className="bg-gradient-to-r from-orange-500 to-red-500 text-white px-4 py-2 rounded-xl font-medium"
          >
            + Add Sub Category
          </button>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="border-b border-gray-200">
                <th className="text-left py-3 px-4 text-gray-600">Name</th>
                <th className="text-left py-3 px-4 text-gray-600">Parent Category</th>
                <th className="text-left py-3 px-4 text-gray-600">Recipes</th>
                <th className="text-left py-3 px-4 text-gray-600">Status</th>
                <th className="text-left py-3 px-4 text-gray-600">Actions</th>
              </tr>
            </thead>
            <tbody>
              {subCategories.map((sub) => (
                <tr key={sub.id} className="border-b border-gray-100 hover:bg-gray-50">
                  <td className="py-3 px-4 font-medium">{sub.name}</td>
                  <td className="py-3 px-4 text-gray-600">{sub.parentCategory}</td>
                  <td className="py-3 px-4">{sub.recipeCount}</td>
                  <td className="py-3 px-4">
                    <span className={`px-2 py-1 rounded-full text-xs font-medium ${
                      sub.status === "Active" ? "bg-green-100 text-green-600" : "bg-red-100 text-red-600"
                    }`}>
                      {sub.status}
                    </span>
                  </td>
                  <td className="py-3 px-4">
                    <button className="text-blue-500 hover:text-blue-600 mr-2">Edit</button>
                    <button onClick={() => toggleStatus(sub.id)} className="text-yellow-500 hover:text-yellow-600 mr-2">
                      {sub.status === "Active" ? "Disable" : "Enable"}
                    </button>
                    <button onClick={() => deleteSubCategory(sub.id)} className="text-red-500 hover:text-red-600">
                      Delete
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Add Modal */}
      {showAddModal && (
        <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl max-w-md w-full p-6">
            <h3 className="text-xl font-bold text-gray-800 mb-4">Add Sub Category</h3>
            <div className="space-y-4">
              <input
                type="text"
                placeholder="Sub Category Name"
                value={newSubCategory.name}
                onChange={(e) => setNewSubCategory({ ...newSubCategory, name: e.target.value })}
                className="w-full px-4 py-2 border border-gray-300 rounded-xl"
              />
              <select
                value={newSubCategory.parentCategory}
                onChange={(e) => setNewSubCategory({ ...newSubCategory, parentCategory: e.target.value })}
                className="w-full px-4 py-2 border border-gray-300 rounded-xl"
              >
                <option value="">Select Parent Category</option>
                {categories.map(cat => <option key={cat} value={cat}>{cat}</option>)}
              </select>
              <textarea
                placeholder="Description (optional)"
                value={newSubCategory.description}
                onChange={(e) => setNewSubCategory({ ...newSubCategory, description: e.target.value })}
                rows="2"
                className="w-full px-4 py-2 border border-gray-300 rounded-xl"
              />
            </div>
            <div className="flex gap-3 mt-6">
              <button onClick={() => setShowAddModal(false)} className="flex-1 px-4 py-2 border border-gray-300 rounded-xl">
                Cancel
              </button>
              <button onClick={handleAddSubCategory} className="flex-1 px-4 py-2 bg-gradient-to-r from-orange-500 to-red-500 text-white rounded-xl">
                Add
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

export default SubCategories;