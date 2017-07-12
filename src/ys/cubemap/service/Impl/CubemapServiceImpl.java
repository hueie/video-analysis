package kams.ys.cubemap.service.Impl;

import javax.annotation.Resource;

import kams.ys.cubemap.service.CubemapService;

import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.rte.fdl.cmmn.AbstractServiceImpl;

@Service("CubemapServiceImpl")
public class CubemapServiceImpl extends AbstractServiceImpl implements CubemapService {

	@Resource(name="CubemapDAO")
	private CubemapDAO CubemapDAO;
	
	@Resource(name="egovMessageSource")
    EgovMessageSource egovMessageSource;
	
	/*
	public List TrandelyList(TrandelyVO vo) throws Exception{
		return TrandelyDAO.TrandelyList(vo);
	}
	
	public int TrandelyListTotCnt(TrandelyVO vo) throws Exception{
		return TrandelyDAO.TrandelyListTotCnt(vo);
	}
	
	public TrandelyVO TrandelyView(TrandelyVO vo) throws Exception {
		return TrandelyDAO.TrandelyView(vo);
	}
	
	public List TrandelyViewList(TrandelyVO vo) throws Exception{
		return TrandelyDAO.TrandelyViewList(vo);
	}
	
	public int TrandelyViewListTotCnt(TrandelyVO vo) throws Exception{
		return TrandelyDAO.TrandelyViewListTotCnt(vo);
	}
	
	public int TrandelyDel(TrandelyVO vo) throws Exception {
	     return TrandelyDAO.TrandelyDel(vo);
	}
	
	public int TrandelyRecordeChk(TrandelyVO vo) throws Exception {
	     return TrandelyDAO.TrandelyRecordeChk(vo);
	}
	
	public int TrandelyAllRecordeDel(TrandelyVO vo) throws Exception {
	     return TrandelyDAO.TrandelyAllRecordeDel(vo);
	}
	
	public void TrandelyAdd(TrandelyVO vo) throws Exception {
		TrandelyDAO.TrandelyAdd(vo);
	}
	
	public void TrandelyModReal(TrandelyVO vo) throws Exception {
		TrandelyDAO.TrandelyModReal(vo);
	}
	
	public void TrandelyRecordeAdd(TrandelyVO vo) throws Exception {
		TrandelyDAO.TrandelyRecordeAdd(vo);
	}
	
	public void TrandelyRecordeDel(TrandelyVO vo) throws Exception {
		TrandelyDAO.TrandelyRecordeDel(vo); 
	}
	
	public void TrandelyRsnAdd(TrandelyVO vo) throws Exception {
		TrandelyDAO.TrandelyRsnAdd(vo); 
	}
	
	public TrandelyVO TrandelyRsnView(TrandelyVO vo) throws Exception {
		return TrandelyDAO.TrandelyRsnView(vo);
	}
	
	*/
}
