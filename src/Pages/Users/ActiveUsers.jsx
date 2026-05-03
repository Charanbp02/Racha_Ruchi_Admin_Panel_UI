import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Search, UserCheck, Mail, Phone, Calendar, Eye, Edit, Trash2 } from "lucide-react";

function ActiveUsers() {
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState("");
  const [filterRole, setFilterRole] = useState("all");

  const [activeUsers, setActiveUsers] = useState([
    { id: 1, name: "Rajesh Kumar", email: "rajesh@example.com", phone: "+91 98765 43210", role: "User", lastActive: "2026-05-02", orders: 24 },
    { id: 2, name: "Priya Sharma", email: "priya@example.com", phone: "+91 87654 32109", role: "User", lastActive: "2026-05-01", orders: 18 },
    { id: 3, name: "Chef Ahmad", email: "ahmad@racharuchi.com", phone: "+91 76543 21098", role: "Chef", lastActive: "2026-05-02", orders: 0 },
    { id: 4, name: "Admin User", email: "admin@racharuchi.com", phone: "+91 65432 10987", role: "Admin", lastActive: "2026-05-02", orders: 0 },
  ]);

  const roles = ["all", "User", "Chef", "Admin"];

  const filteredUsers = activeUsers.filter(user => {
    const matchesSearch = user.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          user.email.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesRole = filterRole === "all" || user.role === filterRole;
    return matchesSearch && matchesRole;
  });

  const getRoleBadge = (role) => {
    const colors = {
      Admin: "bg-purple-100 text-purple-700",
      Chef: "bg-cyan-100 text-cyan-700",
      User: "bg-blue-100 text-blue-700"
    };
    return <span className={`px-2 py-1 rounded-full text-xs font-medium ${colors[role]}`}>{role}</span>;
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-8">
          <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
            <div>
              <h1 className="text-3xl lg:text-4xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                Active Users
              </h1>
              <p className="text-gray-500 mt-2">View all currently active users</p>
            </div>
            <div className="bg-green-100 rounded-xl px-4 py-2 flex items-center gap-2">
              <UserCheck className="w-5 h-5 text-green-600" />
              <span className="font-semibold text-green-600">{activeUsers.length} Active Users</span>
            </div>
          </div>
        </div>

        {/* Filters */}
        <div className="bg-white rounded-2xl p-5 mb-6 shadow-sm">
          <div className="flex flex-col md:flex-row gap-4">
            <div className="flex-1 relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                type="text"
                placeholder="Search active users..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-10 pr-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
            <select
              value={filterRole}
              onChange={(e) => setFilterRole(e.target.value)}
              className="px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white"
            >
              {roles.map(role => (
                <option key={role} value={role}>{role === "all" ? "All Roles" : role}</option>
              ))}
            </select>
          </div>
        </div>

        {/* Desktop Table View */}
        <div className="hidden lg:block bg-white rounded-2xl overflow-hidden shadow-sm">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600">User</th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600">Contact</th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600">Role</th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600">Last Active</th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600">Orders</th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {filteredUsers.map(user => (
                  <tr key={user.id} className="hover:bg-gray-50 transition-all">
                    <td className="px-6 py-4">
                      <div>
                        <p className="font-medium text-gray-800">{user.name}</p>
                        <p className="text-xs text-gray-500">{user.email}</p>
                      </div>
                    </td>
                    <td className="px-6 py-4 text-gray-600">{user.phone}</td>
                    <td className="px-6 py-4">{getRoleBadge(user.role)}</td>
                    <td className="px-6 py-4 text-gray-600">{user.lastActive}</td>
                    <td className="px-6 py-4 text-gray-600">{user.orders}</td>
                    <td className="px-6 py-4">
                      <button className="p-2 text-blue-600 hover:bg-blue-50 rounded-lg">
                        <Eye className="w-4 h-4" />
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* Mobile Card View */}
        <div className="lg:hidden space-y-4">
          {filteredUsers.map(user => (
            <div key={user.id} className="bg-white rounded-2xl p-4 shadow-sm">
              <div className="flex items-start justify-between mb-3">
                <div>
                  <h3 className="font-bold text-gray-800">{user.name}</h3>
                  <p className="text-sm text-gray-500">{user.email}</p>
                </div>
                {getRoleBadge(user.role)}
              </div>
              <div className="space-y-2 mb-3">
                <div className="flex justify-between text-sm">
                  <span className="text-gray-500">Phone:</span>
                  <span className="text-gray-700">{user.phone}</span>
                </div>
                <div className="flex justify-between text-sm">
                  <span className="text-gray-500">Last Active:</span>
                  <span className="text-gray-700">{user.lastActive}</span>
                </div>
              </div>
              <button className="w-full py-2 bg-blue-50 text-blue-600 rounded-lg text-sm flex items-center justify-center gap-1">
                <Eye className="w-4 h-4" />
                View Profile
              </button>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

export default ActiveUsers;