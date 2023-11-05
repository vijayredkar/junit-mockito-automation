package com.banknext.customer.mgt.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.banknext.customer.mgt.repo.model.Customer;
import com.banknext.customer.mgt.service.AccountService;
import com.banknext.customer.mgt.service.CustomerService;
import com.banknext.customer.mgt.service.CustomerServiceImplType1;

@RestController
@RequestMapping("/api/customers/type1/")
public class CustomerMgtControllerType1 {

	@Autowired
    //CustomerService customerServiceImpl;
    CustomerService customerServiceImplType1;
    
	@Autowired
    private AccountService accountService;

    /*
    public CustomerMgtControllerType1(CustomerService customerServiceImpl, AccountService accountService) {
        this.customerServiceImpl = customerServiceImpl;
        this.accountService = accountService;
    }  
    */
    /*
    public CustomerMgtControllerType1(CustomerService customerServiceImpl, AccountService accountService) {
        this.customerServiceImpl = customerServiceImpl;
        this.accountService = accountService;
    }
    */
  
    @GetMapping("/{id}/loan/{loanId}")
    public ResponseEntity<Customer> getCustomerByIdWithContent(@PathVariable("id") int id){
    	Customer customer = customerServiceImplType1.getOptCustomerById(id).get();
        return new ResponseEntity<Customer>(customer, HttpStatus.OK);
    }  
}