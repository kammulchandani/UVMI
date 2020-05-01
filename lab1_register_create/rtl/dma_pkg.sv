/***********************************************************************
 * Package of system-wide definitions for UVM Intermediate lab 1 DMA
 ***********************************************************************
 * Copyright 2019 Mentor Graphics Corporation
 * All Rights Reserved Worldwide
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); 
 * you may not use this file except in compliance with the License.  
 * You may obtain a copy of the License at
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
 * implied.  See the License for the specific language governing
 * permissions and limitations under the License.
 **********************************************************************/

package dma_pkg;

  parameter int BYTES_PER_WORD = 2;

  parameter int DMA_DATA_WIDTH = 16;
  typedef logic [DMA_DATA_WIDTH-1:0] DMA_DATA_T;

  parameter int DMA_ADDR_WIDTH = 16;
  typedef logic [DMA_ADDR_WIDTH-1:0] DMA_ADDR_T;

  // These values are also in the CSV files that feed the Questa Register Assistant
  // RA only accepts numbers, not symbolic names
  parameter int DMA_MEM_SIZE_WORD  = 'h4000;
  parameter int DMA_MEM_SIZE_BYTE  = DMA_MEM_SIZE_WORD * BYTES_PER_WORD;
  parameter int DMA_MEM_START_ADDR = 'h0;
  parameter int DMA_MEM_END_ADDR   = DMA_MEM_SIZE_BYTE;
  parameter int DMA_SRC_ADDR       = 'h8006;
  parameter int DMA_DST_ADDR       = 'h8004;
  parameter int DMA_SIZE_ADDR      = 'h8002;
  parameter int DMA_CSR_ADDR       = 'h8000;

  string addr2str[int] = '{32'h8006:"SRC", 32'h8004:"DST", 32'h8002:"SIZE", 32'h8000:"CSR", default:"MEM"};

  parameter int DMA_CSR_GO    = 0;
  parameter int DMA_CSR_BUSY  = 1;
  parameter int DMA_CSR_DONE  = 2;
  parameter int DMA_CSR_ERROR = 3;

endpackage : dma_pkg
  
