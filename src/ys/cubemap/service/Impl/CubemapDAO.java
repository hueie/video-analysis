package kams.ys.cubemap.service.Impl;

import java.util.List;

import kams.trans.pretran.service.TransPretranVO;
import kams.trans.trandely.service.TrandelyVO;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("CubemapDAO")
public class CubemapDAO extends EgovAbstractDAO {
	
	/*
	public List TrandelyList(TrandelyVO vo) throws Exception {
		return list("TrandelyList", vo);
    }
	
	public int TrandelyListTotCnt(TrandelyVO vo) throws Exception {
		return (Integer)getSqlMapClientTemplate().queryForObject("TrandelyListTotCnt", vo);
    }
	
	public TrandelyVO TrandelyView(TrandelyVO vo) throws Exception {
        return (TrandelyVO) selectByPk("TrandelyView", vo);
    }
	
	public List TrandelyViewList(TrandelyVO vo) throws Exception {
		return list("TrandelyViewList", vo);
    }
	
	public int TrandelyViewListTotCnt(TrandelyVO vo) throws Exception {
		return (Integer)getSqlMapClientTemplate().queryForObject("TrandelyViewListTotCnt", vo);
    }

	public int TrandelyDel(TrandelyVO vo) throws Exception {
		return delete("TrandelyDelete", vo);
    }
	
	public int TrandelyRecordeChk(TrandelyVO vo) throws Exception {
		return (Integer)getSqlMapClientTemplate().queryForObject("TrandelyDeleteChk", vo);
    }
	
	public int TrandelyAllRecordeDel(TrandelyVO vo) throws Exception {
		return delete("TrandelyAllRecordeDel", vo);
    }
	
	public void TrandelyAdd(TrandelyVO vo) throws Exception {
		insert("CreateTrandely", vo);
    }
   
	public void TrandelyModReal(TrandelyVO vo) throws Exception {
		update("UpdateTrandelyAppro", vo);
    }
	
	public void TrandelyRecordeAdd(TrandelyVO vo) throws Exception {
		insert("TrandelyCreateRecorde", vo);
    }
	
	public void TrandelyRecordeDel(TrandelyVO vo) throws Exception {
		 delete("TrandelyRecordeDel", vo);
  }
   
	public void TrandelyRsnAdd(TrandelyVO vo) throws Exception {
		 update("updateTrandelyRsn", vo);
   }
	
	public TrandelyVO TrandelyRsnView(TrandelyVO vo) throws Exception {
        return (TrandelyVO) selectByPk("TrandelyRsnView", vo);
    }
	*/
}
