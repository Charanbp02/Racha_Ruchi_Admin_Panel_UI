import React, { useState } from "react";
import { Search, Plus, Minus, AlertCircle } from "lucide-react";

function ProductStock() {
  const [searchTerm, setSearchTerm] = useState("");
  const [products, setProducts] = useState([
    { id: 1, name: "Organic Bananas", category: "Fruits", price: 4.99, stock: 45, minStock: 20, status: "Good" },
    { id: 2, name: "Fresh Milk", category: "Dairy", price: 3.49, stock: 12, minStock: 15, status: "Low" },
    { id: 3, name: "Chicken Breast", category: "Meat", price: 8.99, stock: 5, minStock: 10, status: "Critical" },
    { id: 4, name: "Whole Wheat Bread", category: "Bakery", price: 3.99, stock: 30, minStock: 10, status: "Good" },
    { id: 5, name: "Organic Apples", category: "Fruits", price: 5.99, stock: 0, minStock: 15, status: "Out" },
  ]);

  const updateStock = (id, change) => {
    setProducts(products.map(product => {
      if (product.id === id) {
        const newStock = Math.max(0, product.stock + change);
        let newStatus = "Good";
        if (newStock === 0) newStatus = "Out";
        else if (newStock <= product.minStock) newStatus = "Critical";
        else if (newStock <= product.minStock * 1.5) newStatus = "Low";
        return { ...product, stock: newStock, status: newStatus };
      }
      return product;
    }));
  };

  const getStatusColor = (status) => {
    const colors = {
      Good: "bg-green-100 text-green-700",
      Low: "bg-yellow-100 text-yellow-700",
      Critical: "bg-orange-100 text-orange-700",
      Out: "bg-red-100 text-red-700"
    };
    return colors[status];
  };

  const filteredProducts = products.filter(product =>
    product.name.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const lowStockCount = products.filter(p => p.status === "Low" || p.status === "Critical").length;

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-8">
          <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
            <div>
              <h1 className="text-3xl lg:text-4xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                Product Stock Management
              </h1>
              <p className="text-gray-500 mt-2">Track and manage inventory levels</p>
            </div>
            <div className="bg-red-100 rounded-xl px-4 py-2 flex items-center gap-2">
              <AlertCircle className="w-5 h-5 text-red-600" />
              <span className="font-semibold text-red-600">{lowStockCount} products need attention</span>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-2xl p-5 mb-6 shadow-sm">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              placeholder="Search products..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full pl-10 pr-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
          {filteredProducts.map(product => (
            <div key={product.id} className="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
              <div className="flex items-start justify-between mb-4">
                <div>
                  <h3 className="font-bold text-gray-800 text-lg">{product.name}</h3>
                  <p className="text-sm text-gray-500">{product.category}</p>
                </div>
                <span className={`px-3 py-1 rounded-full text-xs font-medium ${getStatusColor(product.status)}`}>
                  {product.status === "Out" ? "Out of Stock" : `${product.status} Stock`}
                </span>
              </div>

              <div className="mb-4">
                <div className="flex justify-between text-sm mb-2">
                  <span className="text-gray-500">Current Stock</span>
                  <span className="font-semibold text-gray-800">{product.stock} units</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-2">
                  <div 
                    className={`h-2 rounded-full transition-all ${
                      product.status === "Good" ? "bg-green-500" :
                      product.status === "Low" ? "bg-yellow-500" :
                      product.status === "Critical" ? "bg-orange-500" : "bg-red-500"
                    }`}
                    style={{ width: `${Math.min(100, (product.stock / product.minStock) * 100)}%` }}
                  />
                </div>
                <p className="text-xs text-gray-400 mt-1">Minimum stock: {product.minStock} units</p>
              </div>

              <div className="flex items-center justify-between">
                <div className="flex gap-3">
                  <button 
                    onClick={() => updateStock(product.id, -1)}
                    className="w-10 h-10 bg-red-100 text-red-600 rounded-xl flex items-center justify-center hover:bg-red-200 transition-all"
                    disabled={product.stock === 0}
                  >
                    <Minus className="w-4 h-4" />
                  </button>
                  <span className="text-xl font-bold text-gray-800">{product.stock}</span>
                  <button 
                    onClick={() => updateStock(product.id, 1)}
                    className="w-10 h-10 bg-green-100 text-green-600 rounded-xl flex items-center justify-center hover:bg-green-200 transition-all"
                  >
                    <Plus className="w-4 h-4" />
                  </button>
                </div>
                <span className="text-sm text-gray-500">Rs. {product.price} per unit</span>
              </div>
            </div>
          ))}
        </div>

        {filteredProducts.length === 0 && (
          <div className="bg-white rounded-2xl p-12 text-center">
            <h3 className="text-xl font-semibold text-gray-800 mb-2">No products found</h3>
            <p className="text-gray-500">Try adjusting your search</p>
          </div>
        )}
      </div>
    </div>
  );
}

export default ProductStock;