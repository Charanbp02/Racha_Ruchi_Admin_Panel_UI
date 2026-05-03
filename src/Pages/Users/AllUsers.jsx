import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Search, Eye, Edit, Trash2, UserCheck, UserX, Shield, Mail, Phone, Calendar, Users } from "lucide-react";

function AllUsers() {
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState("");
  const [filterRole, setFilterRole] = useState("all");
  const [filterStatus, setFilterStatus] = useState("all");

  const [users, setUsers] = useState([
    { id: 1, name: "Rajesh Kumar", email: "rajesh@example.com", phone: "+91 98765 43210", role: "User", status: "Active", joinDate: "2024-01-15", lastLogin: "2026-05-02" },
    { id: 2, name: "Priya Sharma", email: "priya@example.com", phone: "+91 87654 32109", role: "User", status: "Active", joinDate: "2024-02-20", lastLogin: "2026-05-01" },
    { id: 3, name: "Chef Ahmad", email: "ahmad@racharuchi.com", phone: "+91 76543 21098", role: "Chef", status: "Active", joinDate: "2024-01-10", lastLogin: "2026-05-02" },
    { id: 4, name: "Admin User", email: "admin@racharuchi.com", phone: "+91 65432 10987", role: "Admin", status: "Active", joinDate: "2023-12-01", lastLogin: "2026-05-02" },
    { id: 5, name: "Vikram Singh", email: "vikram@example.com", phone: "+91 54321 09876", role: "User", status: "Blocked", joinDate: "2024-03-05", lastLogin: "2026-04-28" },
  ]);

  const roles = ["all", "User", "Chef", "Admin"];
  const statuses = ["all", "Active", "Blocked"];

  const filteredUsers = users.filter(user => {
    const matchesSearch = user.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          user.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          user.phone.includes(searchTerm);
    const matchesRole = filterRole === "all" || user.role === filterRole;
    const matchesStatus = filterStatus === "all" || user.status === filterStatus;
    return matchesSearch && matchesRole && matchesStatus;
  });

  const getRoleBadge = (role) => {
    const colors = {
      Admin: "bg-purple-100 text-purple-700",
      Chef: "bg-cyan-100 text-cyan-700",
      User: "bg-blue-100 text-blue-700"
    };
    return <span className={`px-2 py-1 rounded-full text-xs font-medium ${colors[role]}`}>{role}</span>;
  };

  const getStatusBadge = (status) => {
    return status === "Active" 
      ? "bg-green-100 text-green-700" 
      : "bg-red-100 text-red-700";
  };

  const handleDelete = (id) => {
    if (window.confirm("Are you sure you want to delete this user?")) {
      setUsers(users.filter(user => user.id !== id));
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-8">
          <h1 className="text-3xl lg:text-4xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
            All Users
          </h1>
          <p className="text-gray-500 mt-2">View and manage all registered users</p>
        </div>

        {/* Filters */}
        <div className="bg-white rounded-2xl p-5 mb-6 shadow-sm">
          <div className="flex flex-col md:flex-row gap-4">
            <div className="flex-1 relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                type="text"
                placeholder="Search by name, email or phone..."
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
            <select
              value={filterStatus}
              onChange={(e) => setFilterStatus(e.target.value)}
              className="px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white"
            >
              {statuses.map(status => (
                <option key={status} value={status}>{status === "all" ? "All Status" : status}</option>
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
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600">Status</th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600">Join Date</th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600">Last Login</th>
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
                    <td className="px-6 py-4">
                      <span className={`px-2 py-1 rounded-full text-xs font-medium ${getStatusBadge(user.status)}`}>
                        {user.status}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-gray-600">{user.joinDate}</td>
                    <td className="px-6 py-4 text-gray-600">{user.lastLogin}</td>
                    <td className="px-6 py-4">
                      <div className="flex gap-2">
                        <button className="p-2 text-blue-600 hover:bg-blue-50 rounded-lg">
                          <Eye className="w-4 h-4" />
                        </button>
                        <button className="p-2 text-green-600 hover:bg-green-50 rounded-lg">
                          <Edit className="w-4 h-4" />
                        </button>
                        <button onClick={() => handleDelete(user.id)} className="p-2 text-red-600 hover:bg-red-50 rounded-lg">
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </div>
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
                  <span className="text-gray-500">Status:</span>
                  <span className={`px-2 py-0.5 rounded-full text-xs font-medium ${getStatusBadge(user.status)}`}>
                    {user.status}
                  </span>
                </div>
                <div className="flex justify-between text-sm">
                  <span className="text-gray-500">Joined:</span>
                  <span className="text-gray-700">{user.joinDate}</span>
                </div>
              </div>
              <div className="flex gap-2 pt-2 border-t border-gray-100">
                <button className="flex-1 py-2 bg-blue-50 text-blue-600 rounded-lg text-sm flex items-center justify-center gap-1">
                  <Eye className="w-4 h-4" />
                  View
                </button>
                <button className="flex-1 py-2 bg-red-50 text-red-600 rounded-lg text-sm flex items-center justify-center gap-1">
                  <Trash2 className="w-4 h-4" />
                  Delete
                </button>
              </div>
            </div>
          ))}
        </div>

        {filteredUsers.length === 0 && (
          <div className="bg-white rounded-2xl p-12 text-center">
            <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Users className="w-8 h-8 text-gray-400" />
            </div>
            <h3 className="text-xl font-semibold text-gray-800 mb-2">No users found</h3>
            <p className="text-gray-500">Try adjusting your search or filter criteria</p>
          </div>
        )}
      </div>
    </div>
  );
}

export default AllUsers;