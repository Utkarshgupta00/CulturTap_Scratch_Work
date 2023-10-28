const mongoose = require('mongoose');
mongoose.connect('mongodb://localhost:27017/videodataDatabase',{
    useNewUrlParser : true,
    useUnifiedTopology : true,
}).then(()=>{
    console.log('mongodb connected');
}).catch((error)=>{
console.log(error)
});