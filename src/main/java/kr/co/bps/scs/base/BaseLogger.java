package kr.co.bps.scs.base;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

/**
 * @ClassName : BaseLogger.java
 * @Description : BaseLogger class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2015. 11.
 * @version 1.0
 * @see
 * 
 * 
 */
@Service
public class BaseLogger {

	protected final Logger LOGGER = LoggerFactory.getLogger(getClass());

}