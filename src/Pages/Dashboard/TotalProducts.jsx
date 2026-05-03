import React from "react";

function TotalProducts() {
  const products = [
    { id: 1, name: "Racha Ruchi Masala", price: "₹299", stock: 45, status: "In Stock", category: "Spices" },
    { id: 2, name: "Gold Premium Turmeric", price: "₹199", stock: 12, status: "Low Stock", category: "Spices" },
    { id: 3, name: "Kitchen King Masala", price: "₹349", stock: 8, status: "Low Stock", category: "Spices" },
    { id: 4, name: "Cooking Oil - 1L", price: "₹159", stock: 89, status: "In Stock", category: "Essentials" },
    { id: 5, name: "Basmati Rice - 5kg", price: "₹599", stock: 34, status: "In Stock", category: "Rice & Grains" },
  ];

  return (
    <div className="min-h-screen">
      <div className="mb-8">
        <h2 className="text-2xl font-bold text-gray-800 mb-2">
          Total Products
        </h2>
        <p className="text-gray-500">Manage your product inventory</p>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
        <div className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-gray-500 text-sm">Total Products</p>
              <h2 className="text-3xl font-bold text-gray-800 mt-2">86</h2>
            </div>
            <div className="w-12 h-12 rounded-full bg-pink-100 flex items-center justify-center text-2xl font-bold">
              P
            </div>
          </div>
        </div>
        <div className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-gray-500 text-sm">Low Stock</p>
              <h2 className="text-3xl font-bold text-gray-800 mt-2">8</h2>
            </div>
            <div className="w-12 h-12 rounded-full bg-red-100 flex items-center justify-center text-2xl font-bold">
              L
            </div>
          </div>
        </div>
        <div className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-gray-500 text-sm">Out of Stock</p>
              <h2 className="text-3xl font-bold text-gray-800 mt-2">3</h2>
            </div>
            <div className="w-12 h-12 rounded-full bg-gray-100 flex items-center justify-center text-2xl font-bold">
              O
            </div>
          </div>
        </div>
        <div className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-gray-500 text-sm">Categories</p>
              <h2 className="text-3xl font-bold text-gray-800 mt-2">12</h2>
            </div>
            <div className="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center text-2xl font-bold">
              C
            </div>
          </div>
        </div>
      </div>

      {/* Products Table */}
      <div className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl">
        <div className="flex items-center justify-between mb-6">
          <h3 className="text-xl font-bold text-gray-800">Product Inventory</h3>
          <button className="bg-gradient-to-r from-orange-500 to-red-500 text-white px-4 py-2 rounded-xl text-sm font-medium">
            + Add New Product
          </button>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="border-b border-gray-200">
                <th className="text-left py-3 px-4 text-gray-600 font-semibold">Product Name</th>
                <th className="text-left py-3 px-4 text-gray-600 font-semibold">Category</th>
                <th className="text-left py-3 px-4 text-gray-600 font-semibold">Price</th>
                <th className="text-left py-3 px-4 text-gray-600 font-semibold">Stock</th>
                <th className="text-left py-3 px-4 text-gray-600 font-semibold">Status</th>
                <th className="text-left py-3 px-4 text-gray-600 font-semibold">Actions</th>
              </tr>
            </thead>
            <tbody>
              {products.map((product) => (
                <tr key={product.id} className="border-b border-gray-100 hover:bg-gray-50">
                  <td className="py-3 px-4 font-medium text-gray-800">{product.name}</td>
                  <td className="py-3 px-4 text-gray-600">{product.category}</td>
                  <td className="py-3 px-4 text-gray-600">{product.price}</td>
                  <td className="py-3 px-4 text-gray-600">{product.stock}</td>
                  <td className="py-3 px-4">
                    <span className={`px-2 py-1 rounded-full text-xs font-medium
                      ${product.status === 'In Stock' ? 'bg-green-100 text-green-600' : 'bg-red-100 text-red-600'}`}>
                      {product.status}
                    </span>
                  </td>
                  <td className="py-3 px-4">
                    <button className="text-blue-500 hover:text-blue-600 mr-2">Edit</button>
                    <button className="text-red-500 hover:text-red-600">Delete</button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

export default TotalProducts;