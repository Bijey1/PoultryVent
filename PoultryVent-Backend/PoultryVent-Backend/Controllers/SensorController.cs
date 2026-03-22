using Microsoft.AspNetCore.Mvc;
using PoultryVent_Backend.Models;

namespace PoultryVent_Backend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    //URL Structure: api/Sensor
    public class SensorController : Controller
    {
        public static Sensor latestReading = new Sensor //dynamic readings
        {
            Temperature = 1.0, //initial value of sensor
            Humidity=2.0,
            Ammonia = 3.0
        };

        [HttpGet] //Runs when i called a GET 
        public IActionResult Get()
        {
           
            return Ok(latestReading);
        }

        [HttpPost] //Runs when i called POST
        public IActionResult Post([FromBody]Sensor postSensor ) //JSON Format Parameter
        {
            latestReading = postSensor;

            return Ok(new
            {
                messeage = "Successfuly posted"

            });

        }
    }
}
