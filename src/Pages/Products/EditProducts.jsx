import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Search, Edit, Save, X } from "lucide-react";

function EditProducts() {
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState("");
  const [editingId, setEditingId] = useState(null);
  const [editData, setEditData] = useState({});

  const [products, setProducts] = useState([
    { id: 1, name: "Organic Bananas", category: "Fruits", price: 4.99, stock: 45, status: "Active" },
    { id: 2, name: "Fresh Milk", category: "Dairy", price: 3.49, stock: 20, status: "Active" },
    { id: 3, name: "Chicken Breast", category: "Meat", price: 8.99, stock: 5, status: "Active" },
    { id: 4, name: "Whole Wheat Bread", category: "Bakery", price: 3.99, stock: 30, status: "Inactive" },
    { id: 5, name: "Organic Apples", category: "Fruits", price: 5.99, stock: 0, status: "Active" },
  ]);

  const categories = ["Fruits", "Vegetables", "Dairy", "Meat", "Bakery", "Beverages", "Snacks"];

  const filteredProducts = products.filter(product =>
    product.name.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const startEdit = (product) => {
    setEditingId(product.id);
    setEditData(product);
  };

  const cancelEdit = () => {
    setEditingId(null);
    setEditData({});
  };

  const saveEdit = () => {
    setProducts(products.map(product =>
      product.id === editingId ? editData : product
    ));
    setEditingId(null);
    alert("Product updated successfully");
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setEditData({ ...editData, [name]: value });
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-8">
          <h1 className="text-3xl lg:text-4xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
            Edit Products
          </h1>
          <p className="text-gray-500 mt-2">Update product information</p>
        </div>

        <div className="bg-white rounded-2xl p-5 mb-6 shadow-sm">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              placeholder="Search products to edit..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full pl-10 pr-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
        </div>

        <div className="bg-white rounded-2xl overflow-hidden shadow-sm">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600">Product</th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600">Category</th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600">Price</th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600">Stock</th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600">Status</th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {filteredProducts.map(product => (
                  <tr key={product.id} className="hover:bg-gray-50 transition-all">
                    {editingId === product.id ? (
                      <>
                        <td className="px-6 py-4">
                          <input
                            type="text"
                            name="name"
                            value={editData.name}
                            onChange={handleChange}
                            className="px-3 py-1 border border-gray-200 rounded-lg w-full"
                          />
                        </td>
                        <td className="px-6 py-4">
                          <select
                            name="category"
                            value={editData.category}
                            onChange={handleChange}
                            className="px-3 py-1 border border-gray-200 rounded-lg w-full"
                          >
                            {categories.map(cat => (
                              <option key={cat} value={cat}>{cat}</option>
                            ))}
                          </select>
                        </td>
                        <td className="px-6 py-4">
                          <input
                            type="number"
                            name="price"
                            value={editData.price}
                            onChange={handleChange}
                            className="px-3 py-1 border border-gray-200 rounded-lg w-24"
                            step="0.01"
                          />
                        </td>
                        <td className="px-6 py-4">
                          <input
                            type="number"
                            name="stock"
                            value={editData.stock}
                            onChange={handleChange}
                            className="px-3 py-1 border border-gray-200 rounded-lg w-20"
                          />
                        </td>
                        <td className="px-6 py-4">
                          <select
                            name="status"
                            value={editData.status}
                            onChange={handleChange}
                            className="px-3 py-1 border border-gray-200 rounded-lg"
                          >
                            <option value="Active">Active</option>
                            <option value="Inactive">Inactive</option>
                          </select>
                        </td>
                        <td className="px-6 py-4">
                          <div className="flex gap-2">
                            <button onClick={saveEdit} className="p-2 text-green-600 hover:bg-green-50 rounded-lg">
                              <Save className="w-4 h-4" />
                            </button>
                            <button onClick={cancelEdit} className="p-2 text-red-600 hover:bg-red-50 rounded-lg">
                              <X className="w-4 h-4" />
                            </button>
                          </div>
                        </td>
                      </>
                    ) : (
                      <>
                        <td className="px-6 py-4 font-medium text-gray-800">{product.name}</td>
                        <td className="px-6 py-4 text-gray-600">{product.category}</td>
                        <td className="px-6 py-4 font-semibold text-gray-800">Rs. {product.price}</td>
                        <td className="px-6 py-4 text-gray-600">{product.stock}</td>
                        <td className="px-6 py-4">
                          <span className={`px-2 py-1 rounded-full text-xs font-medium ${
                            product.status === "Active" ? "bg-green-100 text-green-700" : "bg-red-100 text-red-700"
                          }`}>
                            {product.status}
                          </span>
                        </td>
                        <td className="px-6 py-4">
                          <button onClick={() => startEdit(product)} className="p-2 text-blue-600 hover:bg-blue-50 rounded-lg">
                            <Edit className="w-4 h-4" />
                          </button>
                        </td>
                      </>
                    )}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}

export default EditProducts;