import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Save, Plug, ShoppingBag, Share2, MessageSquare, Cloud, Database, Zap, Check, TrendingUp } from "lucide-react";

function Integrations() {
  const navigate = useNavigate();
  const [showNotification, setShowNotification] = useState(false);
  const [integrations, setIntegrations] = useState({
    facebook: { enabled: false, appId: "", appSecret: "" },
    instagram: { enabled: false, accessToken: "" },
    googleAnalytics: { enabled: false, trackingId: "" },
    facebookPixel: { enabled: false, pixelId: "" },
    whatsapp: { enabled: false, phoneNumber: "", apiKey: "" },
    slack: { enabled: false, webhookUrl: "" },
    zapier: { enabled: false, apiKey: "" }
  });

  const handleToggle = (integration) => {
    setIntegrations({
      ...integrations,
      [integration]: { ...integrations[integration], enabled: !integrations[integration].enabled }
    });
  };

  const handleChange = (integration, field, value) => {
    setIntegrations({
      ...integrations,
      [integration]: { ...integrations[integration], [field]: value }
    });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    setShowNotification(true);
    setTimeout(() => setShowNotification(false), 3000);
  };

  const IntegrationCard = ({ icon: Icon, title, integration, fields, color }) => (
    <div className="bg-white rounded-2xl shadow-sm p-6 border border-gray-100">
      <div className="flex items-center justify-between mb-4">
        <div className="flex items-center gap-3">
          <div className={`w-10 h-10 ${color} rounded-xl flex items-center justify-center`}>
            <Icon className="w-5 h-5" />
          </div>
          <h3 className="text-lg font-bold text-gray-800">{title}</h3>
        </div>
        <label className="relative inline-flex items-center cursor-pointer">
          <input
            type="checkbox"
            checked={integrations[integration].enabled}
            onChange={() => handleToggle(integration)}
            className="sr-only peer"
          />
          <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"></div>
        </label>
      </div>
      {integrations[integration].enabled && (
        <div className="space-y-3 mt-4 pt-4 border-t border-gray-100">
          {fields.map((field) => (
            <div key={field.name}>
              <label className="block text-sm font-medium text-gray-700 mb-1">{field.label}</label>
              <input
                type={field.type || "text"}
                value={integrations[integration][field.name]}
                onChange={(e) => handleChange(integration, field.name, e.target.value)}
                placeholder={field.placeholder}
                className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
          ))}
        </div>
      )}
    </div>
  );

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      {showNotification && (
        <div className="fixed top-20 right-4 z-50 bg-green-500 text-white px-6 py-3 rounded-xl shadow-lg">
          Integration settings saved successfully
        </div>
      )}

      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-8">
          <h1 className="text-3xl lg:text-4xl font-bold bg-gradient-to-r from-gray-700 to-gray-900 bg-clip-text text-transparent">
            Integrations
          </h1>
          <p className="text-gray-500 mt-2">Connect third-party services and APIs</p>
        </div>

        <form onSubmit={handleSubmit}>
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
            <IntegrationCard
              icon={Share2}
              title="Facebook"
              integration="facebook"
              color="bg-blue-100 text-blue-600"
              fields={[
                { name: "appId", label: "App ID", placeholder: "Enter Facebook App ID" },
                { name: "appSecret", label: "App Secret", type: "password", placeholder: "Enter Facebook App Secret" }
              ]}
            />

            <IntegrationCard
              icon={Share2}
              title="Instagram"
              integration="instagram"
              color="bg-pink-100 text-pink-600"
              fields={[
                { name: "accessToken", label: "Access Token", type: "password", placeholder: "Enter Instagram Access Token" }
              ]}
            />

            <IntegrationCard
              icon={TrendingUp}
              title="Google Analytics"
              integration="googleAnalytics"
              color="bg-green-100 text-green-600"
              fields={[
                { name: "trackingId", label: "Tracking ID", placeholder: "UA-XXXXXXXXX-X" }
              ]}
            />

            <IntegrationCard
              icon={Zap}
              title="Facebook Pixel"
              integration="facebookPixel"
              color="bg-yellow-100 text-yellow-600"
              fields={[
                { name: "pixelId", label: "Pixel ID", placeholder: "Enter Facebook Pixel ID" }
              ]}
            />

            <IntegrationCard
              icon={MessageSquare}
              title="WhatsApp Business"
              integration="whatsapp"
              color="bg-green-100 text-green-600"
              fields={[
                { name: "phoneNumber", label: "Phone Number", placeholder: "+91 XXXXX XXXXX" },
                { name: "apiKey", label: "API Key", type: "password", placeholder: "Enter WhatsApp API Key" }
              ]}
            />

            <IntegrationCard
              icon={MessageSquare}
              title="Slack"
              integration="slack"
              color="bg-purple-100 text-purple-600"
              fields={[
                { name: "webhookUrl", label: "Webhook URL", placeholder: "https://hooks.slack.com/..." }
              ]}
            />

            <IntegrationCard
              icon={Zap}
              title="Zapier"
              integration="zapier"
              color="bg-orange-100 text-orange-600"
              fields={[
                { name: "apiKey", label: "API Key", type: "password", placeholder: "Enter Zapier API Key" }
              ]}
            />
          </div>

          {/* Buttons */}
          <div className="flex gap-4">
            <button
              type="button"
              onClick={() => navigate("/settings")}
              className="flex-1 px-6 py-3 border border-gray-300 text-gray-700 rounded-xl font-medium hover:bg-gray-50 transition-all"
            >
              Cancel
            </button>
            <button
              type="submit"
              className="flex-1 px-6 py-3 bg-gradient-to-r from-gray-700 to-gray-900 text-white rounded-xl font-medium hover:shadow-lg transition-all flex items-center justify-center gap-2"
            >
              <Save className="w-5 h-5" />
              Save Integrations
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

export default Integrations;