import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Search, UserX, Mail, Phone, Calendar, AlertCircle, CheckCircle, Trash2, UserCheck } from "lucide-react";

function BlockedUsers() {
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState("");
  const [showNotification, setShowNotification] = useState(false);

  const [blockedUsers, setBlockedUsers] = useState([
    { id: 1, name: "Vikram Singh", email: "vikram@example.com", phone: "+91 54321 09876", reason: "Spam activity", blockedDate: "2026-04-28", blockedBy: "Admin" },
    { id: 2, name: "Rahul Mehta", email: "rahul@example.com", phone: "+91 43210 98765", reason: "Multiple violations", blockedDate: "2026-04-25", blockedBy: "Admin" },
    { id: 3, name: "Neha Kapoor", email: "neha@example.com", phone: "+91 32109 87654", reason: "Suspicious activity", blockedDate: "2026-04-20", blockedBy: "Admin" },
  ]);

  const handleUnblock = (id) => {
    setBlockedUsers(blockedUsers.filter(user => user.id !== id));
    setShowNotification(true);
    setTimeout(() => setShowNotification(false), 3000);
  };

  const filteredUsers = blockedUsers.filter(user =>
    user.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    user.email.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      {showNotification && (
        <div className="fixed top-20 right-4 z-50 bg-green-500 text-white px-6 py-3 rounded-xl shadow-lg">
          User unblocked successfully
        </div>
      )}

      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-8">
          <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
            <div>
              <h1 className="text-3xl lg:text-4xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                Blocked Users
              </h1>
              <p className="text-gray-500 mt-2">View and manage blocked users</p>
            </div>
            <div className="bg-red-100 rounded-xl px-4 py-2 flex items-center gap-2">
              <UserX className="w-5 h-5 text-red-600" />
              <span className="font-semibold text-red-600">{blockedUsers.length} Blocked Users</span>
            </div>
          </div>
        </div>

        {/* Search */}
        <div className="bg-white rounded-2xl p-5 mb-6 shadow-sm">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              placeholder="Search blocked users..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full pl-10 pr-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
        </div>

        {/* Blocked Users List */}
        <div className="space-y-4">
          {filteredUsers.map(user => (
            <div key={user.id} className="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
              <div className="flex flex-col lg:flex-row lg:items-start lg:justify-between gap-4">
                <div className="flex-1">
                  <div className="flex items-center gap-3 mb-2">
                    <div className="w-10 h-10 bg-red-100 rounded-full flex items-center justify-center">
                      <UserX className="w-5 h-5 text-red-600" />
                    </div>
                    <div>
                      <h3 className="font-bold text-gray-800 text-lg">{user.name}</h3>
                      <p className="text-sm text-gray-500">{user.email}</p>
                    </div>
                  </div>
                  <div className="grid grid-cols-1 md:grid-cols-3 gap-3 mt-3">
                    <div className="flex items-center gap-2 text-sm text-gray-600">
                      <Phone className="w-4 h-4" />
                      {user.phone}
                    </div>
                    <div className="flex items-center gap-2 text-sm text-gray-600">
                      <Calendar className="w-4 h-4" />
                      Blocked: {user.blockedDate}
                    </div>
                    <div className="flex items-center gap-2 text-sm text-gray-600">
                      <AlertCircle className="w-4 h-4" />
                      By: {user.blockedBy}
                    </div>
                  </div>
                  <div className="mt-3 p-3 bg-red-50 rounded-xl">
                    <p className="text-sm text-red-700 flex items-center gap-2">
                      <AlertCircle className="w-4 h-4" />
                      Reason: {user.reason}
                    </p>
                  </div>
                </div>
                <div className="flex gap-3">
                  <button 
                    onClick={() => handleUnblock(user.id)}
                    className="px-4 py-2 bg-green-100 text-green-700 rounded-xl font-medium hover:bg-green-200 transition-all flex items-center gap-2"
                  >
                    <CheckCircle className="w-4 h-4" />
                    Unblock User
                  </button>
                  <button className="px-4 py-2 bg-red-100 text-red-700 rounded-xl font-medium hover:bg-red-200 transition-all flex items-center gap-2">
                    <Trash2 className="w-4 h-4" />
                    Delete
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>

        {filteredUsers.length === 0 && (
          <div className="bg-white rounded-2xl p-12 text-center">
            <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <UserCheck className="w-8 h-8 text-green-600" />
            </div>
            <h3 className="text-xl font-semibold text-gray-800 mb-2">No blocked users</h3>
            <p className="text-gray-500">All users are currently active</p>
          </div>
        )}
      </div>
    </div>
  );
}

export default BlockedUsers;