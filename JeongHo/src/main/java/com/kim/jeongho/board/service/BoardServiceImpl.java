package com.kim.jeongho.board.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kim.jeongho.board.domain.BoardVO;
import com.kim.jeongho.board.mapper.BoardMapper;
import com.kim.jeongho.cmm.domain.Criteria;

import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class BoardServiceImpl implements BoardService {
	
	@Autowired
	private BoardMapper boardMapper;

	@Override
	public void register(BoardVO boardVO) {
		log.info("BoardServiceImpl > register");
		
		boardMapper.insertSelectKey(boardVO);
	}

	@Override
	public BoardVO get(Long bno) {
		log.info("BoardServiceImpl > get");
		
		return boardMapper.read(bno);
	}

	@Override
	public boolean modify(BoardVO boardVO) {
		log.info("BoardServiceImpl > modify");
		
		return boardMapper.update(boardVO) == 1;
	}

	@Override
	public boolean remove(Long bno) {
		log.info("BoardServiceImpl > remove");
		
		return boardMapper.delete(bno) == 1;
	}

	@Override
	public List<BoardVO> getList(Criteria cri) { 
		log.info("BoardServiceImpl > getListWithPaging");
		
		return boardMapper.getListWithPaging(cri); 
	}

	@Override
	public int getTotal(Criteria cri) {
		
		return boardMapper.getTotalCount(cri);
	}
	
 
}
