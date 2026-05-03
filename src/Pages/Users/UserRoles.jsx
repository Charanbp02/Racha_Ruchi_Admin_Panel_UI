import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Shield, Edit, Users, ChefHat, Crown, Plus, Trash2 } from "lucide-react";

function UserRoles() {
  const navigate = useNavigate();
  const [showAddModal, setShowAddModal] = useState(false);
  const [newRole, setNewRole] = useState({ name: "", description: "" });

  const [roles, setRoles] = useState([
    { id: 1, name: "Admin", description: "Full system access", userCount: 12, status: "Active", permissions: 24 },
    { id: 2, name: "Chef", description: "Can manage recipes and videos", userCount: 48, status: "Active", permissions: 16 },
    { id: 3, name: "User", description: "Regular user access", userCount: 12440, status: "Active", permissions: 8 },
    { id: 4, name: "Moderator", description: "Can moderate content", userCount: 6, status: "Inactive", permissions: 12 },
  ]);

  const handleAddRole = () => {
    if (newRole.name) {
      setRoles([...roles, {
        id: roles.length + 1,
        ...newRole,
        userCount: 0,
        status: "Active",
        permissions: 0
      }]);
      setShowAddModal(false);
      setNewRole({ name: "", description: "" });
    }
  };

  const getRoleIcon = (name) => {
    if (name === "Admin") return <Crown className="w-6 h-6 text-purple-600" />;
    if (name === "Chef") return <ChefHat className="w-6 h-6 text-cyan-600" />;
    return <Shield className="w-6 h-6 text-blue-600" />;
  };

  const getRoleColor = (name) => {
    if (name === "Admin") return "bg-purple-100";
    if (name === "Chef") return "bg-cyan-100";
    return "bg-blue-100";
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-8">
          <div>
            <h1 className="text-3xl lg:text-4xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
              User Roles
            </h1>
            <p className="text-gray-500 mt-2">Manage user roles and their permissions</p>
          </div>
          <button 
            onClick={() => setShowAddModal(true)}
            className="px-5 py-2.5 bg-gradient-to-r from-blue-500 to-purple-600 text-white rounded-xl font-medium hover:shadow-lg transition-all flex items-center gap-2"
          >
            <Plus className="w-5 h-5" />
            Add Role
          </button>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {roles.map(role => (
            <div key={role.id} className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-all">
              <div className="flex items-start justify-between mb-4">
                <div className="flex items-center gap-4">
                  <div className={`w-14 h-14 ${getRoleColor(role.name)} rounded-xl flex items-center justify-center`}>
                    {getRoleIcon(role.name)}
                  </div>
                  <div>
                    <h3 className="text-xl font-bold text-gray-800">{role.name}</h3>
                    <p className="text-sm text-gray-500 mt-1">{role.description}</p>
                  </div>
                </div>
                <span className={`px-2 py-1 rounded-full text-xs font-medium ${
                  role.status === "Active" ? "bg-green-100 text-green-700" : "bg-red-100 text-red-700"
                }`}>
                  {role.status}
                </span>
              </div>
              <div className="grid grid-cols-2 gap-4 mb-4 pt-4 border-t border-gray-100">
                <div className="bg-gray-50 rounded-xl p-3 text-center">
                  <p className="text-2xl font-bold text-gray-800">{role.userCount}</p>
                  <p className="text-xs text-gray-500">Users</p>
                </div>
                <div className="bg-gray-50 rounded-xl p-3 text-center">
                  <p className="text-2xl font-bold text-gray-800">{role.permissions}</p>
                  <p className="text-xs text-gray-500">Permissions</p>
                </div>
              </div>
              <div className="flex gap-3">
                <button className="flex-1 px-4 py-2 bg-blue-100 text-blue-700 rounded-xl font-medium hover:bg-blue-200 transition-all flex items-center justify-center gap-2">
                  <Edit className="w-4 h-4" />
                  Edit Role
                </button>
                <button className="flex-1 px-4 py-2 bg-purple-100 text-purple-700 rounded-xl font-medium hover:bg-purple-200 transition-all flex items-center justify-center gap-2">
                  <Shield className="w-4 h-4" />
                  Permissions
                </button>
              </div>
            </div>
          ))}
        </div>

        {/* Add Role Modal */}
        {showAddModal && (
          <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
            <div className="bg-white rounded-2xl max-w-md w-full p-6">
              <h3 className="text-xl font-bold text-gray-800 mb-4">Add New Role</h3>
              <div className="space-y-4">
                <input
                  type="text"
                  placeholder="Role Name"
                  value={newRole.name}
                  onChange={(e) => setNewRole({ ...newRole, name: e.target.value })}
                  className="w-full px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
                <textarea
                  placeholder="Description"
                  value={newRole.description}
                  onChange={(e) => setNewRole({ ...newRole, description: e.target.value })}
                  rows="3"
                  className="w-full px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
              <div className="flex gap-3 mt-6">
                <button onClick={() => setShowAddModal(false)} className="flex-1 px-4 py-2 border border-gray-300 rounded-xl">Cancel</button>
                <button onClick={handleAddRole} className="flex-1 px-4 py-2 bg-gradient-to-r from-blue-500 to-purple-600 text-white rounded-xl">Add Role</button>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

export default UserRoles;