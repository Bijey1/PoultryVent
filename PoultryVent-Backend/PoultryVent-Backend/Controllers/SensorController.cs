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
            Temperature = 2 //initial value of sensor
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
