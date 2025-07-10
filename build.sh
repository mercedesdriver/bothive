
from flask import Flask, render_template, jsonify, request
from flask_pymongo import PyMongo
from bson.objectid import ObjectId
from datetime import datetime
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

app = Flask(__name__, template_folder='../frontend', static_folder='../frontend/static')

# Configure MongoDB
app.config["MONGO_URI"] = os.getenv("MONGODB_URI", "mongodb://localhost:27017/bothive")
mongo = PyMongo(app)
db = mongo.db

# Pink theme configuration
PINK_THEME = {
    "primary": "#ff4d8d",
    "secondary": "#ff85b3",
    "background": "#1a1a1a",
    "text": "#ffffff",
    "neon_glow": "0 0 10px rgba(255, 77, 141, 0.8)"
}

@app.route('/')
def home():
    """Render pink-themed dashboard"""
    bots = list(db.bots.find().sort("created_at", -1).limit(10))
    return render_template('index.html', 
                         theme=PINK_THEME,
                         bots=bots,
                         title="BotHive 🎀")

@app.route('/api/bots', methods=['GET', 'POST'])
def manage_bots():
    """Bot management API"""
    if request.method == 'POST':
        # Create new bot
        bot_data = {
            "name": request.json.get("name"),
            "type": request.json.get("type"),
            "status": "stopped",
            "created_at": datetime.utcnow(),
            "theme_color": PINK_THEME["primary"]
        }
        result = db.bots.insert_one(bot_data)
        return jsonify({
            "message": "Bot created!",
            "bot_id": str(result.inserted_id),
            "theme": PINK_THEME
        }), 201
    
    # Get all bots
    bots = list(db.bots.find())
    for bot in bots:
        bot["_id"] = str(bot["_id"])
    return jsonify(bots)

@app.route('/api/bots/<bot_id>', methods=['PUT', 'DELETE'])
def bot_operations(bot_id):
    """Start/Stop/Delete bots"""
    if request.method == 'PUT':
        # Update bot status
        new_status = request.json.get("status")
        db.bots.update_one(
            {"_id": ObjectId(bot_id)},
            {"$set": {"status": new_status}}
        )
        return jsonify({
            "message": f"Bot {new_status}",
            "status": new_status,
            "theme": PINK_THEME
        })
    
    # Delete bot
    db.bots.delete_one({"_id": ObjectId(bot_id)})
    return jsonify({
        "message": "Bot deleted",
        "theme": PINK_THEME
    })

@app.route('/api/theme', methods=['GET'])
def get_theme():
    """Returns the pink theme configuration"""
    return jsonify(PINK_THEME)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.getenv("PORT", 5000)), debug=True)
