import React, { useState } from "react";
import { Star, ThumbsUp, Flag, CheckCircle, XCircle } from "lucide-react";

function ProductReviews() {
  const [reviews, setReviews] = useState([
    { id: 1, product: "Organic Bananas", customer: "Rajesh Kumar", rating: 5, review: "Excellent quality! Very fresh.", date: "2026-05-01", status: "Pending", helpful: 24 },
    { id: 2, product: "Fresh Milk", customer: "Priya Sharma", rating: 4, review: "Good product, delivery was prompt.", date: "2026-04-30", status: "Approved", helpful: 12 },
    { id: 3, product: "Chicken Breast", customer: "Amit Singh", rating: 3, review: "Average quality, could be better.", date: "2026-04-29", status: "Pending", helpful: 5 },
    { id: 4, product: "Organic Apples", customer: "Neha Gupta", rating: 5, review: "Sweet and fresh apples!", date: "2026-04-28", status: "Approved", helpful: 32 },
  ]);

  const handleApprove = (id) => {
    setReviews(reviews.map(review => 
      review.id === id ? { ...review, status: "Approved" } : review
    ));
  };

  const handleReject = (id) => {
    setReviews(reviews.filter(review => review.id !== id));
  };

  const renderStars = (rating) => {
    return "★".repeat(rating) + "☆".repeat(5 - rating);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      <div className="px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        <div className="mb-8">
          <h1 className="text-3xl lg:text-4xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
            Product Reviews
          </h1>
          <p className="text-gray-500 mt-2">Moderate and manage customer reviews</p>
        </div>

        <div className="space-y-4">
          {reviews.map(review => (
            <div key={review.id} className="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
              <div className="flex flex-col lg:flex-row lg:items-start lg:justify-between gap-4">
                <div className="flex-1">
                  <div className="flex items-center gap-3 mb-2 flex-wrap">
                    <h3 className="font-bold text-gray-800">{review.product}</h3>
                    <div className="flex items-center gap-1">
                      <span className="text-yellow-500 text-sm">{renderStars(review.rating)}</span>
                      <span className="text-sm text-gray-500">({review.rating})</span>
                    </div>
                  </div>
                  <p className="text-gray-600 mb-3">"{review.review}"</p>
                  <div className="flex items-center gap-4 text-sm text-gray-500">
                    <span>By {review.customer}</span>
                    <span>•</span>
                    <span>{review.date}</span>
                    <div className="flex items-center gap-1">
                      <ThumbsUp className="w-4 h-4" />
                      <span>{review.helpful}</span>
                    </div>
                  </div>
                </div>
                <div className="flex gap-3">
                  {review.status === "Pending" ? (
                    <>
                      <button 
                        onClick={() => handleApprove(review.id)}
                        className="px-4 py-2 bg-green-100 text-green-700 rounded-xl font-medium hover:bg-green-200 transition-all flex items-center gap-2"
                      >
                        <CheckCircle className="w-4 h-4" />
                        Approve
                      </button>
                      <button 
                        onClick={() => handleReject(review.id)}
                        className="px-4 py-2 bg-red-100 text-red-700 rounded-xl font-medium hover:bg-red-200 transition-all flex items-center gap-2"
                      >
                        <XCircle className="w-4 h-4" />
                        Reject
                      </button>
                    </>
                  ) : (
                    <span className="px-4 py-2 bg-green-100 text-green-700 rounded-xl font-medium flex items-center gap-2">
                      <CheckCircle className="w-4 h-4" />
                      Approved
                    </span>
                  )}
                  <button className="px-4 py-2 bg-gray-100 text-gray-700 rounded-xl font-medium hover:bg-gray-200 transition-all flex items-center gap-2">
                    <Flag className="w-4 h-4" />
                    Report
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

export default ProductReviews;