import React, { useState } from "react";

function TotalUsers() {
  const [searchTerm, setSearchTerm] = useState("");

  const users = [
    { id: 1, name: "Ahmad", email: "ahmad@racharuchi.com", status: "Active", joinDate: "2024-01-15" },
    { id: 2, name: "Priya Sharma", email: "priya@example.com", status: "Active", joinDate: "2024-02-20" },
    { id: 3, name: "Rajesh Kumar", email: "rajesh@example.com", status: "Inactive", joinDate: "2024-01-10" },
    { id: 4, name: "Neha Gupta", email: "neha@racharuchi.com", status: "Active", joinDate: "2023-12-01" },
    { id: 5, name: "Vikram Singh", email: "vikram@example.com", status: "Active", joinDate: "2024-03-05" },
  ];

  const filteredUsers = users.filter(user => 
    user.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    user.email.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="min-h-screen">
      <div className="mb-8">
        <h2 className="text-2xl font-bold text-gray-800 mb-2">
          Total Users
        </h2>
        <p className="text-gray-500">Manage and monitor all registered users</p>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
        <div className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-gray-500 text-sm">Total Users</p>
              <h2 className="text-3xl font-bold text-gray-800 mt-2">12.5K</h2>
            </div>
            <div className="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center text-2xl font-bold">
              U
            </div>
          </div>
        </div>
        <div className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-gray-500 text-sm">Active Users</p>
              <h2 className="text-3xl font-bold text-gray-800 mt-2">10.2K</h2>
            </div>
            <div className="w-12 h-12 rounded-full bg-green-100 flex items-center justify-center text-2xl font-bold">
              A
            </div>
          </div>
        </div>
        <div className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-gray-500 text-sm">Inactive Users</p>
              <h2 className="text-3xl font-bold text-gray-800 mt-2">2.3K</h2>
            </div>
            <div className="w-12 h-12 rounded-full bg-red-100 flex items-center justify-center text-2xl font-bold">
              I
            </div>
          </div>
        </div>
        <div className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-gray-500 text-sm">New This Month</p>
              <h2 className="text-3xl font-bold text-gray-800 mt-2">240</h2>
            </div>
            <div className="w-12 h-12 rounded-full bg-purple-100 flex items-center justify-center text-2xl font-bold">
              N
            </div>
          </div>
        </div>
      </div>

      {/* Users Table */}
      <div className="bg-white border border-gray-200 rounded-3xl p-6 shadow-xl">
        <div className="flex items-center justify-between mb-6">
          <h3 className="text-xl font-bold text-gray-800">User List</h3>
          <input
            type="text"
            placeholder="Search users..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="px-4 py-2 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-orange-500"
          />
        </div>

        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="border-b border-gray-200">
                <th className="text-left py-3 px-4 text-gray-600 font-semibold">Name</th>
                <th className="text-left py-3 px-4 text-gray-600 font-semibold">Email</th>
                <th className="text-left py-3 px-4 text-gray-600 font-semibold">Status</th>
                <th className="text-left py-3 px-4 text-gray-600 font-semibold">Join Date</th>
                <th className="text-left py-3 px-4 text-gray-600 font-semibold">Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredUsers.map((user) => (
                <tr key={user.id} className="border-b border-gray-100 hover:bg-gray-50">
                  <td className="py-3 px-4 font-medium text-gray-800">{user.name}</td>
                  <td className="py-3 px-4 text-gray-600">{user.email}</td>
                  <td className="py-3 px-4">
                    <span className={`px-2 py-1 rounded-full text-xs font-medium
                      ${user.status === 'Active' ? 'bg-green-100 text-green-600' : 'bg-red-100 text-red-600'}`}>
                      {user.status}
                    </span>
                  </td>
                  <td className="py-3 px-4 text-gray-600">{user.joinDate}</td>
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

export default TotalUsers;