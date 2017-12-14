#include "tableManager.h"
#include "literal.h"

TableManager& TableManager::getInstance() {
  static TableManager instance;
  return instance;
}

const Literal* TableManager::getSymbol(const std::string& name) {
  SymbolTable& symbolTable = tables[currentScope];
  return symbolTable.getValue(name);
}

const Node* TableManager::getParam(const std::string& name) {
  FunctionTable& funcTable = functions[currentScope];
  // std::cout << "found? " << funcTable.found(name) << std::endl;
  return funcTable.getParam(name);
}

const Node* TableManager::getSuite(const std::string& name) {
  FunctionTable& funcTable = functions[currentScope];
  // std::cout << "found? " << funcTable.found(name) << std::endl;
  return funcTable.getValue(name);
}

void TableManager::insertSymbol(const std::string& name, const Literal* val) {
  SymbolTable& symbolTable = tables[currentScope];
  symbolTable.insert(name, val);
  // std::cout << "symbol: " << name << ",  currentScope: " << currentScope << std::endl;
}

void TableManager::insertFunction(const std::string& name, const Node* params, const Node* suite) {
  //std::cout << "-------TableManager::insertFunction---1----" << std::endl;
  FunctionTable& funcTable = functions[currentScope];
  funcTable.insert(name, suite);
  if (params) {
    funcTable.insertParam(name, params);
  }
  // SymbolTable temp;
  // tables.push_back(temp);
  // FunctionTable funcTemp;
  // functions.push_back(funcTemp);
  // std::cout << "func: " << name << ", currentScope: " << currentScope << std::endl;
  //std::cout << "-------TableManager::insertFunction---2----" << std::endl;
}

bool TableManager::checkSymbol(const std::string& name) const {
  // std::cout << "Symbol: " << name << ", bool: " << tables[currentScope].found(name) << std::endl;
  return tables[currentScope].found(name);
}

bool TableManager::checkFuncName(const std::string& name) const {
  return functions[currentScope].found(name) ;
}

void TableManager::pushScope(const std::string& name) {
  SymbolTable temp;
  tables.push_back(temp);

  FunctionTable funcTemp;
  if (checkFuncName(name)) {
    funcTemp = functions[currentScope];
    //std::cout << "-------pushScope---3----" << std::endl;
  }
  functions.push_back(funcTemp);
  currentScope++;
}

void TableManager::popScope() {
  if (currentScope > 0) {
    currentScope--;
    tables.pop_back();
    functions.pop_back();
  }
}

void TableManager::display() const {
  for (unsigned int i = 0; i < tables.size(); i++) {

    tables[i].display();
  }
  for (auto& func : functions) {
    func.display();
  }
}
