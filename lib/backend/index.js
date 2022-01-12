const express = require('express');
const { PythonShell } = require('python-shell');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');
const cron = require('node-cron');
const bcrypt = require('bcrypt');
var objectId = require('mongodb').ObjectId;

const app = express();
const port = 5000;
const hostname = "127.0.0.1";
app.use(bodyParser.urlencoded({
    extended: true
}));
app.use(bodyParser.json());
const saltRounds = 10;
var tick = 0

mongoose.connect('mongodb://localhost/stonks', { useNewUrlParser: true, useUnifiedTopology: true });
mongoose.pluralize(null);

app.use(cors({origin: 'http://localhost:4200'}));

cron.schedule('00 16 * * 1-5', () => {
    console.log('Running cron job');
    PythonShell.run('main.py', null, function (err, data) {
        if (err) throw err;
        console.log(data.toString());
    });
});


const MARKETSTANDARDS = mongoose.model("MARKETSTANDARDS", mongoose.Schema({
    _id: String,
}));

const SYMBOLS = mongoose.model("SYMBOLS", mongoose.Schema({
    _id: String,
    name: String,
    is_index: { type: Boolean, default: false },
    market_standard: { type: String, default: "NIFTY" },
    expense_ratio: { type: Number, default: 0 },
    dividend: { type: Number, default: 0 },
    series: { type: String, default: "EQ" },
    about: { type: String, default: "-" },
}));

const ARTICLES = mongoose.model("ARTICLES", mongoose.Schema({
    _id: { type: mongoose.Schema.Types.ObjectId, auto: true },
    title: String,
    summary: String,
    for_symbol: { type: String, default: "GENERAL" },
    image_link: { type: String, default: "https://img.etimg.com/thumb/msid-71194865,width-1200,height-900,resizemode-4,imgsize-243814/sensex-nifty-live-today-2019-09-19.jpg" },
    timestamp: { type: Date, default: Date.now },
}));

const TRIVIA = mongoose.model("TRIVIA", mongoose.Schema({
    _id: { type: mongoose.Schema.Types.ObjectId, auto: true },
    title: String,
    description: String,
    video_url: String,
}));

const USER = mongoose.model("USERS", mongoose.Schema({
    _id: String,
    password: String,
    is_admin: Boolean,
}));

// TO DO: Change response status codes from 200 to accurate status codes for the relevant action.

app.get('/api/stonks/niftyData', function (req, res) {
    res.header("Access-Control-Allow-Origin", "*");
    // SYMBOLS.find({}).exec(function (err, data) {
    //     if (err)
    //         console.log(err);
    //     res.json(data);
    // });
    SYMBOLS.aggregate([{
        $lookup: {
            from: "NIFTY",
            localField: "_id",
            foreignField: "_id",
            as: "analysis"
        },
    }, { $match: { market_standard: "NIFTY" } }]).exec(function (err, data) {
        if (err)
            console.log(err);
        res.json(data);
    });
});

app.get('/api/stonks/bankNiftyData', function (req, res) {
    res.header("Access-Control-Allow-Origin", "*");
    // SYMBOLS.find({}).exec(function (err, data) {
    //     if (err)
    //         console.log(err);
    //     res.json(data);
    // });
    SYMBOLS.aggregate([{
        $lookup: {
            from: "BANKNIFTY",
            localField: "_id",
            foreignField: "_id",
            as: "analysis"
        },
    }, { $match: { market_standard: "BANKNIFTY" } }]).exec(function (err, data) {
        if (err)
            console.log(err);
        res.json(data);
    });
});

app.get('/api/stonks/SYMBOLS/:id', function (req, res) {
    res.header("Access-Control-Allow-Origin", "*");
    SYMBOLS.find({ "_id": req.params.id }).exec(function (err, data) {
        if (err)
            console.log(err);
        res.json(data);
    });
});

app.get('/api/stonks/articles_for/:id', function (req, res) {
    res.header("Access-Control-Allow-Origin", "*");
    ARTICLES.find({ "for_symbol": req.params.id }).exec(function (err, data) {
        if (err)
            console.log(err);
        res.json(data);
    });
});

app.post('/api/stonks/add_symbol', function (req, res) {
    console.log(req.body);
    res.header("Access-Control-Allow-Origin", "*");
    const symbol = new SYMBOLS({
        _id: req.body._id,
        name: req.body.name,
        is_index: req.body.is_index,
        market_standard: req.body.market_standard,
        expense_ratio: req.body.expense_ratio,
        dividend: req.body.dividend,
        series: req.body.series,
        about: req.body.about,
    });
    console.log(symbol);
    SYMBOLS.find({"_id": symbol._id}).exec(function (err, data){
        if(err)
            console.log(err);
        else if(data.length > 0){
            
            res.send("exists");
        }
        else{
            MARKETSTANDARDS.find({"_id": symbol.market_standard}).exec(function (err, data){
                if(err)
                    console.log(err);
                else if(data.length == 0){
                    
                    res.send("standard");
                }
                else{
                    var options = {
                        args: [symbol._id, symbol.market_standard]
                    }
                    
                    PythonShell.run('SingleStockAnalysis.py', options, function (err, data) {
                        if (err) throw err;
                        if(data.toString().includes("STATUS: SUCCESS")){
                            symbol.save().then(result => {
                                
                                res.send("success");
                                console.log(result);
                            }).catch(err => {
                                console.log(err);
                            });
                        }
                        else{
                            
                            res.send("failed")
                        }
                    });
                }
            });
        }
    });
    // MARKETSTANDARDS.find({}).exec(function (err, data) {
    //     if (err)
    //         console.log(err);
    //     for (var i = 0; i < data.length; i++) {
    //         if (market_standard == data[i]._id) {
    //             const symbol = new SYMBOLS({
    //                 _id: req.body._id,
    //                 name: req.body.name,
    //                 is_index: req.body.is_index,
    //                 market_standard: req.body.market_standard,
    //                 expense_ratio: req.body.expense_ratio,
    //                 dividend: req.body.dividend,
    //                 series: req.body.series,
    //                 about: req.body.about,
    //             });
    //             symbol.save().then(result => {
    //                 
    //                 res.send("success");
    //                 console.log(result);
    //             }).catch(err => {
    //                 console.log(err);
    //             });
    //             break;
    //         }
    //     }
    // });
});

// app.post('/api/stonks/add_index',  function(req, res){
//     console.log(req.body);
//     const marketStandard = new MARKETSTANDARDS({
//     _id: req.body._id,
//     });
//     marketStandard.save().then(result =>{
//         console.log(result);
//     }).catch(err => {
//         console.log(err);
//     });
// });

app.post('/api/stonks/publish_article',  function (req, res) {
    console.log(req.body);
    res.header("Access-Control-Allow-Origin", "*");
    const article = new ARTICLES({
        title: req.body.title,
        summary: req.body.summary,
        for_symbol: req.body.for_symbol,
        image_link: req.body.image_link,
    });
    SYMBOLS.find({ "_id":  article.for_symbol}).exec(function (err, data) {
        if (err)
            console.log(err);
        if(data.length != 0 || article.for_symbol == "GENERAL") {
            article.save().then(result => {
                
                res.send("success");
                console.log(result);
            }).catch(err => {
                console.log(err);
            });
        }
        else {
            res.send("symbol");
        }
    });
});

app.put('/api/stonks/edit_article',  function (req, res) {
    console.log(req.body);
    res.header("Access-Control-Allow-Origin", "*");
    const article = new ARTICLES({
        title: req.body.title,
        summary: req.body.summary,
        for_symbol: req.body.for_symbol,
        image_link: req.body.image_link,
    });
    SYMBOLS.find({ "_id":  article.for_symbol}).exec(function (err, data) {
        if (err)
            console.log(err);
        if(data.length != 0 || article.for_symbol == "GENERAL") {
            ARTICLES.updateOne({"_id": objectId(req.body._id)}, {$set: {
                "title": req.body.title,
                "summary": req.body.summary,
                "for_symbol": req.body.for_symbol,
                "image_link": req.body.image_link,
            }},).exec(function (err, data){
                if(err)
                    console.log(err);
                
                res.send("success");
            });
        }
        else {
            res.send("symbol");
        }
    });
});

app.delete('/api/stonks/delete_article',  function (req, res) {
    console.log(req.body);
    res.header("Access-Control-Allow-Origin", "*");
    ARTICLES.deleteOne({ "_id": objectId(req.body._id) }).exec(function (err, data) {
        if (err)
            console.log(err);
        
        res.send("success");
    });
});

app.post('/api/stonks/add_trivia',  function (req, res) {
    console.log(req.body);
    res.header("Access-Control-Allow-Origin", "*");
    const trivia = new TRIVIA({
        title: req.body.title,
        description: req.body.description,
        video_url: req.body.video_url,
    });
    trivia.save().then(result => {
        
        res.send("success");
        console.log(result);
    }).catch(err => {
        console.log(err);
    });
});

app.put('/api/stonks/edit_trivia',  function (req, res) {
    console.log(req.body);
    res.header("Access-Control-Allow-Origin", "*");
    TRIVIA.updateOne({"_id": objectId(req.body._id)}, {$set: {
        "title": req.body.title,
        "description": req.body.description,
        "video_url": req.body.video_url,
    }},).exec(function (err, data){
        if(err)
            console.log(err);
        
        res.send("success");
    });
});

app.put('/api/stonks/edit_symbol',  function (req, res) {
    console.log(req.body);
    SYMBOLS.updateOne({"_id": req.body._id}, {$set: {
        "name": req.body.name,
        "market_standard": req.body.market_standard,
        "expense_ratio": req.body.expense_ratio,
        "dividend": req.body.dividend,
        "series": req.body.series,
        "about": req.body.about,
    }},).exec(function (err, data){
        if(err)
            console.log(err);
        
        res.send("success");
    });
    // res.header("Access-Control-Allow-Origin", "*");
    // MARKETSTANDARDS.find({"_id": req.body.market_standard}).exec(function (err, data){
    //     if(err)
    //         console.log(err);
    //     else if(data.length == 0){
    //         
    //         res.send("standard");
    //     }
    //     else{

    //     }
    // });
});

app.delete('/api/stonks/delete_trivia',  function (req, res) {
    console.log(req.body);
    res.header("Access-Control-Allow-Origin", "*");
    TRIVIA.deleteOne({ "_id": objectId(req.body._id) }).exec(function (err, data) {
        if (err)
            console.log(err);
        
        res.send("success");
    });
});

app.delete('/api/stonks/delete_user',  function (req, res) {
    res.header("Access-Control-Allow-Origin", "*");
    USER.findOne({ "_id": req.body.username }).exec(function (err, data) {
        
        if (err) {
            console.log(err);
        }
        if (data == null) {
            
            res.send("username");
        }
        // else if(data.is_admin){
        //     
        //     res.send("admin");
        // }
        else if(String(data.password) != req.body.password){
            
            res.send("incorrect");
        }
        else{
            USER.deleteOne({ "_id": req.body.username }).exec(function (err, data) {
                if (err)
                    console.log(err);
                
                res.send("success");
            });
        }
    });
});

app.delete('/api/stonks/delete_symbol',  function (req, res) {
    console.log(req.body);
    res.header("Access-Control-Allow-Origin", "*");
    SYMBOLS.findOne({ "_id": req.body._id }).exec(function (err, data) {
        if (err)
            console.log(err);
        if (data.is_index)
            res.status(403)
        else {
            tick += 1;
            var DELETEANALYSIS = mongoose.model("DeleteAnalysis" + tick, mongoose.Schema({
                _id: String,
            }), String(data.market_standard));
            SYMBOLS.deleteOne({ "_id": req.body._id }).exec(function (err, data) {
                if (err)
                    console.log(err);
                DELETEANALYSIS.deleteOne({ "_id": req.body._id }).exec(function (err, data) {
                    if (err)
                        console.log(err);
                    
                    res.send("success");
                });
            });
        }
    });
});

app.post('/api/stonks/authenticate',  function (req, res) {
    var username = req.body.username;
    var password = req.body.password;
    res.header("Access-Control-Allow-Origin", "*");
    USER.findOne({ "_id": username }).exec(function (err, data) {
        if (err)
            console.log(err);
        if(data == null){
            
            res.send("username");
        }
        else {
            bcrypt.compare(password, data.password, function(err, result) {
                if(err) res.send("error");
                if(result) {
                    if (data.is_admin) {
                        
                        res.send("admin");
                    }
                    else {
                        
                        res.send("user");
                    }
                }
                else {
                    
                    res.send("incorrect");
                }
            });
        }
    });
});

app.post('/api/stonks/register',  function (req, res) {
    res.header("Access-Control-Allow-Origin", "*");
    USER.findOne({ "_id": req.body.username }).exec(function (err, data) {
        
        if (err) {
            console.log(err);
        }
        if (data != null) {
            res.send("exists");
        }
        else if (data == null) {
            bcrypt.hash(req.body.password, saltRounds, function(err, hash) {
                const user = new USER({
                    _id: req.body.username,
                    password: err ? req.body.password : hash,
                    is_admin: req.body.is_admin,
                });
                user.save().then(result => {
                    res.send("success")
                    console.log(result);
                }).catch(err => {
                    console.log(err);
                });
            });
        }
    })
});

app.put('/api/stonks/change_password',  function (req, res) {
    res.header("Access-Control-Allow-Origin", "*");
    USER.findOne({ "_id": req.body.username }).exec(function (err, data) {
        
        if (err) {
            console.log(err);
        }
        if (data == null) {
            
            res.send("username");
        }
        else if(String(data.password) != req.body.old_password){
            
            res.send("incorrect");
        }
        else{
            USER.updateOne({"_id": req.body.username}, {$set: {"password": req.body.password}}).exec(function (err, data){
                if(err)
                    console.log(err);
                
                res.send("success");
            });
        }
    });
});

app.get('/api/stonks/MARKETSTANDARDS', function (req, res) {
    res.header("Access-Control-Allow-Origin", "*");
    MARKETSTANDARDS.find({}).exec(function (err, data) {
        if (err)
            console.log(err);
        res.json(data);
    });
});

app.get('/api/stonks/ARTICLES', function (req, res) {
    res.header("Access-Control-Allow-Origin", "*");
    ARTICLES.find({}).sort('-timestamp').exec(function (err, data) {
        if (err)
            console.log(err);
        res.json(data);
    });
});

app.get('/api/stonks/TRIVIA', function (req, res) {
    res.header("Access-Control-Allow-Origin", "*");
    TRIVIA.find({}).exec(function (err, data) {
        if (err)
            console.log(err);
        res.json(data);
    });
});


collections = []

MARKETSTANDARDS.find({}).exec(function (err, data) {
    if (err)
        console.log(err)
    for (i = 0; i < data.length; i++) {
        collections.push(data[i]["_id"])
    }
    for (i = 0; i < collections.length; i++) {
        const ANALYSIS = mongoose.model(collections[i], mongoose.Schema({
            _id: String,
            close: Number,
            date: String,
            is_bullish: Number,
            sm_close: Number,
            sm_date: String,
            sm_volatility: Number,
            sm_beta: Number,
            sm_price_up: Number,
            sm_avg_price_up: Number,
            sm_price_down: Number,
            sm_avg_price_down: Number,
            oy_close: Number,
            oy_date: String,
            oy_volatility: Number,
            oy_beta: Number,
            oy_price_up: Number,
            oy_avg_price_up: Number,
            oy_price_down: Number,
            oy_avg_price_down: Number,
            ty_close: Number,
            ty_date: String,
            ty_volatility: Number,
            ty_price_up: Number,
            ty_avg_price_up: Number,
            ty_price_down: Number,
            ty_avg_price_down: Number,
            ty_beta: Number,
            fy_close: Number,
            fy_date: String,
            fy_volatility: Number,
            fy_beta: Number,
            fy_price_up: Number,
            fy_avg_price_up: Number,
            fy_price_down: Number,
            fy_avg_price_down: Number,
        }));

        app.get('/api/stonks/' + collections[i], function (req, res) {
            res.header("Access-Control-Allow-Origin", "*");
            ANALYSIS.find({}).exec(function (err, data) {
                if (err)
                    console.log(err);
                res.json(data);
            });
        });
    }
});

app.listen(port, hostname, () => {
    console.log(`Server running at http://${hostname}:${port}/`);
});