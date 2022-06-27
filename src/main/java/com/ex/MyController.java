package com.ex;

import com.ex.model.City;
import com.ex.service.ICityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class MyController {

    @Autowired
    private ICityService cityService;

    @GetMapping("/showCities")
    public String findCities(Model model) {

        List<City> cities;
        cities = (List<City>) cityService.findAll();

        model.addAttribute("cities", cities);

        return "showCities";
    }
}
